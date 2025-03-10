/* Copyright 2025 Northwestern University,
 *                   Carnegie Mellon University University
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author(s): David Krasowska <krasow@u.northwestern.edu>
 *            Ethan Meitz <emeitz@andrew.cmu.edu>
 */

#include <initializer_list>
#include <iostream>
#include <string>  //needed for return type of toString methods
#include <type_traits>

#include "accessors.h"
#include "callback.h"
#include "cupynumeric.h"
#include "cupynumeric/operators.h"
#include "jlcxx/jlcxx.hpp"
#include "jlcxx/stl.hpp"
#include "legate.h"
#include "legate/mapping/machine.h"
#include "legate/timing/timing.h"
#include "legion.h"
#include "legion/legion_config.h"
#include "types.h"

struct WrapCppOptional {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    typedef typename TypeWrapperT::type WrappedT;
    wrapped.template constructor<typename WrappedT::value_type>();
  }
};

cupynumeric::NDArray get_slice(cupynumeric::NDArray arr,
                               std::vector<legate::Slice> slices) {
  switch (slices.size()) {
    case 1: {
      std::initializer_list<legate::Slice> slice_list = {slices[0]};
      return arr[slice_list];
    }
    case 2: {
      std::initializer_list<legate::Slice> slice_list = {slices[0], slices[1]};
      return arr[slice_list];
    }
    default: {
      assert(0 && "dim gteq 3 not supported yet\b");
    }
  };
  assert(0 && "you should not enter here\n");
}

// std::string get_machine_info() {
//   auto runtime = legate::Runtime::get_runtime();
//   return runtime->get_machine().to_string();
// }

// void print_machine_info() { std::cout << get_machine_info() << std::endl; }

JLCXX_MODULE define_julia_module(jlcxx::Module& mod) {
  wrap_privilege_modes(mod);
  wrap_type_enums(mod);
  wrap_type_getters(mod);
  wrap_unary_ops(mod);
  wrap_binary_ops(mod);
  wrap_unary_reds(mod);

  using jlcxx::ParameterList;
  using jlcxx::Parametric;
  using jlcxx::TypeVar;

  // These are the types/dims used to generate templated functions
  // i.e. only these types/dims can be used from Julia side
  using fp_types = ParameterList<double, float>;
  using int_types = ParameterList<int8_t, int16_t, int32_t, int64_t>;
  using uint_types = ParameterList<uint8_t, uint16_t, uint32_t, uint64_t>;

  using all_types =
      ParameterList<double, float, int8_t, int16_t, int32_t, int64_t, uint8_t,
                    uint16_t, uint32_t, uint64_t>;
  using allowed_dims = ParameterList<std::integral_constant<int_t, 1>,
                                     std::integral_constant<int_t, 2>,
                                     std::integral_constant<int_t, 3>>;
  using privilege_modes = ParameterList<
      std::integral_constant<legion_privilege_mode_t, LEGION_WRITE_DISCARD>,
      std::integral_constant<legion_privilege_mode_t, LEGION_READ_ONLY>>;

  // These are used in stencil.cc, seem important
  mod.method("start_legate", [] { legate::start(); });  // in legate/runtime.h
  mod.method(
      "initialize_cunumeric",
      &cupynumeric::initialize);  // in operators.h defined in runtime.cc???
  mod.method("legate_finish", &legate::finish);  // in legate/runtime.h

  //   mod.method("get_machine_info", &get_machine_info);
  //   mod.method("print_machine_info", &print_machine_info);

  // Need to put this before the optional definition,
  // but StdOptional has to be defined by NDArray::type
  auto ndarry_type = mod.add_type<cupynumeric::NDArray>("NDArray")
                         .constructor<const cupynumeric::NDArray&>();

  mod.add_type<Parametric<TypeVar<1>>>("StdOptional")
      .apply<std::optional<legate::Type>, std::optional<cupynumeric::NDArray>,
             std::optional<int64_t>>(WrapCppOptional());

  mod.add_type<legate::LogicalStore>("LogicalStore");
  mod.add_type<legate::Slice>("LegateSlice")
      .constructor<std::optional<int64_t>, std::optional<int64_t>>();

  mod.add_type<std::vector<legate::Slice>>("LegateSlices")
      .method("push", [](std::vector<legate::Slice>& v, legate::Slice s) {
        v.push_back(s);
      });

  mod.add_type<legate::Scalar>("LegateScalar")
      .constructor<float>()
      .constructor<double>();  // julia lets me make with ints???

  jlcxx::stl::apply_stl<legate::Scalar>(
      mod);  // enable std::vector<legate::Scalar>

  ndarry_type.method("dim", &cupynumeric::NDArray::dim)
      .method("_size",
              &cupynumeric::NDArray::size)  // hide with underscore cause in
                                            // Julia `size` is same as shape
      .method("shape", &cupynumeric::NDArray::shape)
      .method("type", &cupynumeric::NDArray::type)
      .method("copy", &cupynumeric::NDArray::copy)
      .method("assign",
              (void(cupynumeric::NDArray::*)(const cupynumeric::NDArray&)) &
                  cupynumeric::NDArray::assign)
      .method("_reshape", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                              std::vector<int64_t>)) &
                              cupynumeric::NDArray::reshape)
      .method("as_type", &cupynumeric::NDArray::as_type)
      .method("unary_op", &cupynumeric::NDArray::unary_op)
      // ew but necessary cause theres an overload in operators.cc
      .method("unary_reduction", static_cast<void (cupynumeric::NDArray::*)(
                                     int32_t, cupynumeric::NDArray)>(
                                     &cupynumeric::NDArray::unary_reduction))
      .method("binary_op", &cupynumeric::NDArray::binary_op)
      .method("get_store", &cupynumeric::NDArray::get_store)
      .method("random", &cupynumeric::NDArray::random)
      .method("fill", &cupynumeric::NDArray::fill)
      //   .method("_dot_three_arg", &cupynumeric::NDArray::dot)
      .method("add", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                         const cupynumeric::NDArray&) const) &
                         cupynumeric::NDArray::operator+)
      .method("multiply", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                              const cupynumeric::NDArray&) const) &
                              cupynumeric::NDArray::operator*)
      .method("add_scalar", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                                const legate::Scalar&) const) &
                                cupynumeric::NDArray::operator+)
      .method("multiply_scalar", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                                     const legate::Scalar&) const) &
                                     cupynumeric::NDArray::operator*);
  // replacing this with get_slice custom method
  // .method("get_slice",
  //         (cupynumeric::NDArray(cupynumeric::NDArray::*)(
  //             std::initializer_list<cupynumeric::slice>) const) &
  //             cupynumeric::NDArray::operator[]);

  mod.method("get_slice", &get_slice);

  auto ndarray_accessor =
      mod.add_type<Parametric<TypeVar<1>, TypeVar<2>>>("NDArrayAccessor");
  ndarray_accessor
      .apply_combination<ApplyNDArrayAccessor, all_types, allowed_dims>(
          WrapNDArrayAccessor());

  mod.method("_zeros", &cupynumeric::zeros);  // operators.cc, 152
  mod.method("_full", &cupynumeric::full);    // operators.cc, 162
  mod.method("_dot", &cupynumeric::dot);      // operators.cc, 263
  mod.method("_sum", &cupynumeric::sum);      // operators.cc, 303
  mod.method("_add", &cupynumeric::add);
  mod.method("_multiply", &cupynumeric::multiply);
  mod.method("_random_ndarray", &cupynumeric::random);

  mod.add_type<legate::timing::Time>("Time").method(
      "value", &legate::timing::Time::value);
  mod.method("time_microseconds", &legate::timing::measure_microseconds);
  mod.method("time_nanoseconds", &legate::timing::measure_nanoseconds);

  mod.method("mapper_register_oom_callback",
             &callback::mapper_register_oom_callback);
  mod.method("mapper_remove_usage", &callback::mapper_remove_usage);
  mod.method("mapper_alloc", &callback::mapper_alloc);

  //.method("add_eq", &cupynumeric::NDArray::operator+=)
  //.method("multiply_eq", &cupynumeric::NDArray::operator*=);

  //   mod.add_type<Parametric<TypeVar<1>, TypeVar<2>>>("AccessorTypeContainer")
  //     .apply_combination<ApplyAccessorTypeContainer, all_types,
  //     allowed_dims>(EmptyWrapper());

  // template<PrivilegeMode,typename,int,typename,typename,bool> class
  // FieldAccessor;
  //  Wrap FieldAccessor so we can create the more species RO and WO accessors
  //   auto parent_type_field = jlcxx::julia_type("AbstractFieldAccessor");
  //   auto FieldAccessor =
  //       mod.add_type<Parametric<TypeVar<1>, TypeVar<2>, TypeVar<3>>>(
  //           "FieldAccessor", parent_type_field);
  //   FieldAccessor.apply_combination<ApplyFieldAccessor, privilege_modes,
  //   all_types,
  //                                   allowed_dims>(EmptyWrapper());

  //   // Creates tempalte instantiations forall combinations of RO and WO
  //   Accessors auto parent_type_RO = jlcxx::julia_type("AbstractAccessorRO");
  //   auto accessor_base_RO = mod.add_type<Parametric<TypeVar<1>, TypeVar<2>>>(
  //       "AccessorRO", parent_type_RO);
  //   accessor_base_RO.apply_combination<ApplyAccessorRO, all_types,
  //   allowed_dims>(
  //       WrapAccessorRO());

  //   auto parent_type_WO = jlcxx::julia_type("AbstractAccessorWO");
  //   auto accessor_base_WO = mod.add_type<Parametric<TypeVar<1>, TypeVar<2>>>(
  //       "AccessorWO", parent_type_WO);
  //   accessor_base_WO.apply_combination<ApplyAccessorWO, all_types,
  //   allowed_dims>(
  //       WrapAccessorWO());

  /// Add a non-member function that uses Foo3
  //   typedef jlcxx::combine_types<ApplyAccessorRO, all_types, allowed_dims>
  //   accessor_ro_types;
  //   jlcxx::for_each_type<accessor_ro_types>(GetAccessorROFreeMethod(mod));

  // MAKE THIS USE `allowed_dims` instead of hard coded
  // mod.add_type<Parametric<TypeVar<1>>>("Point")
  //   .apply<Legion::Point<1>, Legion::Point<2>, Legion::Point<3>>([](auto
  //   wrapped){

  //   });

  // mod.method("make_point", &Realm::make_point);

  // Creates tempalte instantiations forall combinations of RO and WO Accessors
  //   auto parent_type_RO = jlcxx::julia_type("AbstractAccessorRO");
  //   auto accessor_base_RO = mod.add_type<Parametric<TypeVar<1>,
  //   TypeVar<2>>>("AccessorRO", parent_type_RO);
  //   accessor_base_RO.apply_combination<ApplyAccessorRO, fp_types,
  //   allowed_dims>(WrapAccessorRO());

  //   auto parent_type_WO = jlcxx::julia_type("AbstractAccessorWO");
  //   auto accessor_base_WO = mod.add_type<Parametric<TypeVar<1>,
  //   TypeVar<2>>>("AccessorWO", parent_type_WO);
  //   accessor_base_WO.apply_combination<ApplyAccessorWO, fp_types,
  //   allowed_dims>(WrapAccessorWO());
}
