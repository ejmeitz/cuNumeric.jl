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

#include <iostream>
#include <string>  //needed for return type of toString methods
#include <type_traits>

#include "accessors.h"
#include "cupynumeric.h"
#include "jlcxx/jlcxx.hpp"
#include "legate.h"
#include "legate/mapping/machine.h"
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

// double read_double_2d(legate::AccessorRO<double, 2> acc,
//                       std::vector<uint64_t> dims) {
//   Legion::Point<2> p = {dims[0], dims[1]};
//   return acc.read(p);
// }

// void write_double_2d(legate::AccessorWO<double, 2> acc,
//                      std::vector<uint64_t> dims, double val) {
//   Legion::Point<2> p = {dims[0], dims[1]};
//   acc.write(p, val);
// }

// WHY THIS NOT WORK????? no symbol for to_string???
void get_machine_info() {
  auto runtime = legate::Runtime::get_runtime();
  std::string s = runtime->get_machine().to_string();
  std::cout << s << std::endl;
}

JLCXX_MODULE define_julia_module(jlcxx::Module& mod) {

  wrap_privilege_modes(mod);
  wrap_type_enums(mod);
  wrap_type_getters(mod);

  using jlcxx::ParameterList;
  using jlcxx::Parametric;
  using jlcxx::TypeVar;

  // These are the types/dims used to generate templated functions
  // i.e. only these types/dims can be used from Julia side
  using fp_types = ParameterList<double, float>;
  using int_types = ParameterList<int8_t, int16_t, int32_t, int64_t>;
  using uint_types = ParameterList<uint8_t, uint16_t, uint32_t, uint64_t>;

  using all_types =  ParameterList<double, float, int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t>;
  using allowed_dims = ParameterList<std::integral_constant<int_t, 1>,
                                     std::integral_constant<int_t, 2>,
                                     std::integral_constant<int_t, 3>>;
  using privilege_modes = ParameterList<
      std::integral_constant<legion_privilege_mode_t, LEGION_WRITE_DISCARD>,
      std::integral_constant<legion_privilege_mode_t, LEGION_READ_ONLY>>;

  // These are used in stencil.cc, seem important
  mod.method("start_legate", &legate::start);  // in legate/runtime.h
  mod.method(
      "initialize_cunumeric",
      &cupynumeric::initialize);  // in operators.h defined in runtime.cc???
  mod.method("legate_finish", &legate::finish);  // in legate/runtime.h

  // mod.add_type<legate::Runtime>("LegateRuntime");
  // mod.add_type<legate::mapping::Machine>("Machine");
  // .method("to_string", &legate::mapping::Machine::to_string);

  //// WHY THIS NOT WORK?????
  mod.method("get_machine_info", &get_machine_info);

  mod.add_type<Parametric<TypeVar<1>>>("StdOptional")
      .apply<std::optional<legate::Type>>(WrapCppOptional());

  mod.add_type<legate::LogicalStore>(
      "LogicalStore");  // might be useful with ndarray.get_store

  mod.add_type<legate::Scalar>("LegateScalar")
      .constructor<float>()
      .constructor<double>();  // julia lets me make with ints???

  //   mod.add_type<legate::AccessorRO<double, 2>>("AccessorRO_double_2d");
  //   mod.add_type<legate::AccessorRO<float, 2>>("AccessorRO_float_2d");

  //   mod.add_type<legate::AccessorWO<float, 2>>("AccessorWO_float_2d");
  //   mod.add_type<legate::AccessorWO<double, 2>>("AccessorWO_double_2d");

  //   mod.method("read_double_2d", &read_double_2d);
  //   mod.method("write_double_2d", &write_double_2d);

  // https://github.com/nv-legate/cupynumeric/blob/5371ab3ead17c295ef05b51e2c424f62213ffd52/src/cupynumeric/ndarray.h
  auto ndarray_base =
      mod.add_type<cupynumeric::NDArray>("NDArray")
          // .constructor<cupynumeric::NDArray&&>()
          .constructor<const cupynumeric::NDArray&>()
          .method("dim", &cupynumeric::NDArray::dim)
          .method("size", &cupynumeric::NDArray::size)
          .method("type", &cupynumeric::NDArray::type)
          .method("as_type", &cupynumeric::NDArray::as_type)
          .method("binary_op", &cupynumeric::NDArray::binary_op)
          .method("get_store", &cupynumeric::NDArray::get_store)
          .method("random", &cupynumeric::NDArray::random)
          .method("fill", &cupynumeric::NDArray::fill)
          .method("add", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                             const cupynumeric::NDArray&) const) &
                             cupynumeric::NDArray::operator+)
          .method("multiply", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                                  const cupynumeric::NDArray&) const) &
                                  cupynumeric::NDArray::operator*)
          .method("add_scalar", (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                                    const legate::Scalar&) const) &
                                    cupynumeric::NDArray::operator+)
          .method("multiply_scalar",
                  (cupynumeric::NDArray(cupynumeric::NDArray::*)(
                      const legate::Scalar&) const) &
                      cupynumeric::NDArray::operator*);


  mod.add_type<Parametric<TypeVar<1>, TypeVar<2>>>("AccessorTypeContainer")
    .apply_combination<ApplyAccessorTypeContainer, all_types, allowed_dims>(EmptyWrapper());
 
  // template<PrivilegeMode,typename,int,typename,typename,bool> class
  // FieldAccessor;
  //  Wrap FieldAccessor so we can create the more species RO and WO accessors
  auto parent_type_field = jlcxx::julia_type("AbstractFieldAccessor");
  auto FieldAccessor =
      mod.add_type<Parametric<TypeVar<1>, TypeVar<2>, TypeVar<3>>>(
          "FieldAccessor", parent_type_field);
  FieldAccessor.apply_combination<ApplyFieldAccessor, privilege_modes, all_types,
                                  allowed_dims>(EmptyWrapper());

  // Creates tempalte instantiations forall combinations of RO and WO Accessors
  auto parent_type_RO = jlcxx::julia_type("AbstractAccessorRO");
  auto accessor_base_RO = mod.add_type<Parametric<TypeVar<1>, TypeVar<2>>>(
      "AccessorRO", parent_type_RO);
  accessor_base_RO.apply_combination<ApplyAccessorRO, all_types, allowed_dims>(
      WrapAccessorRO());

  auto parent_type_WO = jlcxx::julia_type("AbstractAccessorWO");
  auto accessor_base_WO = mod.add_type<Parametric<TypeVar<1>, TypeVar<2>>>(
      "AccessorWO", parent_type_WO);
  accessor_base_WO.apply_combination<ApplyAccessorWO, all_types, allowed_dims>(
      WrapAccessorWO());

  /// Add a non-member function that uses Foo3
//   typedef jlcxx::combine_types<ApplyAccessorRO, all_types, allowed_dims> accessor_ro_types;
//   jlcxx::for_each_type<accessor_ro_types>(GetAccessorROFreeMethod(mod));

  //.method("add_eq", &cupynumeric::NDArray::operator+=)
  //.method("multiply_eq", &cupynumeric::NDArray::operator*=);

  mod.method("_zeros", &cupynumeric::zeros);  // operators.cc, 152
  mod.method("_full", &cupynumeric::full);    // operators.cc, 162
  mod.method("_dot", &cupynumeric::dot);      // operators.cc, 263
  mod.method("_sum", &cupynumeric::sum);      // operators.cc, 303
  // mod.method("add", &cupynumeric::add);
  // mod.method("multiply", &cupynumeric::multiply);
}