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

#include "cupynumeric.h"
#include "jlcxx/jlcxx.hpp"
#include "legate.h"
#include "legion.h"

// legate::PrimitiveType takes a value from the legate::Type::Code enum
// but I can't wrap that enum explicitly so I will hardcode
// an enum in Julia that has the same mappings and just
// pass integeters to construct PrimitiveTypes

// cuPyNumeric C++ API:
// https://github.com/nv-legate/cupynumeric/blob/branch-24.11/src/cupynumeric/operators.h

// legate::Type defined here:
// https://github.com/nv-legate/legate/blob/main/src/core/type/type_info.h
// can find inside of conda here:
// /home/emeitz/.conda/envs/cunumeric/include/legate/legate/type/type_info.h

struct WrapCppOptional {
  template <typename TypeWrapperT>
  void operator()(TypeWrapperT&& wrapped) {
    typedef typename TypeWrapperT::type WrappedT;
    wrapped.template constructor<typename WrappedT::value_type>();
  }
};

double read_double_2d(legate::AccessorRO<double, 2> acc,
                      std::vector<uint64_t> dims) {
  Legion::Point<2> p = {dims[0], dims[1]};
  return acc.read(p);
}

void write_double_2d(legate::AccessorWO<double, 2> acc,
                     std::vector<uint64_t> dims, double val) {
  Legion::Point<2> p = {dims[0], dims[1]};
  acc.write(p, val);
}

JLCXX_MODULE define_julia_module(jlcxx::Module& mod) {
  // These are used in stencil.cc, seem important
  mod.method("start_legate", &legate::start);  // no idea where this is
  mod.method("initialize_cunumeric", &cupynumeric::initialize);  // runtime.cc
  mod.method("legate_finish", &legate::finish);  // no idea where this is

  mod.add_bits<legion_type_id_t>("LegionType", jlcxx::julia_type("CppEnum"));
  mod.set_const("LEGION_TYPE_BOOL", 0);
  mod.set_const("LEGION_TYPE_INT8", 1);
  mod.set_const("LEGION_TYPE_INT16", 2);
  mod.set_const("LEGION_TYPE_INT32", 3);
  mod.set_const("LEGION_TYPE_INT64", 4);
  mod.set_const("LEGION_TYPE_UINT8", 5);
  mod.set_const("LEGION_TYPE_UINT16", 6);
  mod.set_const("LEGION_TYPE_UINT32", 7);
  mod.set_const("LEGION_TYPE_UINT64", 8);
  mod.set_const("LEGION_TYPE_FLOAT16", 9);
  mod.set_const("LEGION_TYPE_FLOAT32", 10);
  mod.set_const("LEGION_TYPE_FLOAT64", 11);
  mod.set_const("LEGION_TYPE_COMPLEX32", 12);
  mod.set_const("LEGION_TYPE_COMPLEX64", 13);
  mod.set_const("LEGION_TYPE_COMPLEX128", 14);
  mod.set_const("LEGION_TYPE_TOTAL", 15);

  mod.add_bits<legate::Type::Code>("TypeCode", jlcxx::julia_type("CppEnum"));
  mod.set_const("BOOL", legion_type_id_t::LEGION_TYPE_BOOL);
  mod.set_const("INT8", legion_type_id_t::LEGION_TYPE_INT8);
  mod.set_const("INT16", legion_type_id_t::LEGION_TYPE_INT16);
  mod.set_const("INT32", legion_type_id_t::LEGION_TYPE_INT32);
  mod.set_const("INT64", legion_type_id_t::LEGION_TYPE_INT64);
  mod.set_const("UINT8", legion_type_id_t::LEGION_TYPE_UINT8);
  mod.set_const("UINT16", legion_type_id_t::LEGION_TYPE_UINT16);
  mod.set_const("UINT32", legion_type_id_t::LEGION_TYPE_UINT32);
  mod.set_const("UINT64", legion_type_id_t::LEGION_TYPE_UINT64);
  mod.set_const("FLOAT16", legion_type_id_t::LEGION_TYPE_FLOAT16);
  mod.set_const("FLOAT32", legion_type_id_t::LEGION_TYPE_FLOAT32);
  mod.set_const("FLOAT64", legion_type_id_t::LEGION_TYPE_FLOAT64);
  mod.set_const("COMPLEX64", legion_type_id_t::LEGION_TYPE_COMPLEX64);
  mod.set_const("COMPLEX128", legion_type_id_t::LEGION_TYPE_COMPLEX128);
  mod.set_const("NIL", 15);
  mod.set_const("BINARY", 16);
  mod.set_const("FIXED_ARRAY", 17);
  mod.set_const("STRUCT", 18);
  mod.set_const("STRING", 19);
  mod.set_const("LIST", 20);

  mod.add_type<legate::Type>("LegateType");

  mod.add_type<jlcxx::Parametric<jlcxx::TypeVar<1>>>("StdOptional")
      .apply<std::optional<legate::Type>>(WrapCppOptional());

  // these likely aren't needed. LegateTypeAllocated
  mod.method("bool_", &legate::bool_);
  mod.method("int8", &legate::int8);
  mod.method("int16", &legate::int16);
  mod.method("int32", &legate::int32);
  mod.method("int64", &legate::int64);
  mod.method("uint8", &legate::uint8);
  mod.method("uint16", &legate::uint16);
  mod.method("uint32", &legate::uint32);
  mod.method("uint64", &legate::uint64);
  mod.method("float16", &legate::float16);
  mod.method("float32", &legate::float32);
  mod.method("float64", &legate::float64);
  // mod.method("complex32", &legate::complex32);
  mod.method("complex64", &legate::complex64);
  mod.method("complex128", &legate::complex128);

  mod.add_type<legate::LogicalStore>(
      "LogicalStore");  // might be useful with ndarray.get_store

  // in scalar.h

  mod.add_type<legate::Scalar>("LegateScalar")
      .constructor<float>()
      .constructor<double>();  // julia lets me make with ints???

  mod.add_type<legate::AccessorRO<double, 2>>("AccessorRO_double_2d");
  mod.add_type<legate::AccessorRO<float, 2>>("AccessorRO_float_2d");

  mod.add_type<legate::AccessorWO<float, 2>>("AccessorWO_float_2d");
  mod.add_type<legate::AccessorWO<double, 2>>("AccessorWO_double_2d");

  // mod.add_type<jlcxx::Parametric<jlcxx::TypeVar<1>, jlcxx::TypeVar<2>>>("AccessorRO_2d")
  //   .apply_combination<legate::AccessorRO,
  //    jlcxx::ParameterList<float, double>,
  //    jlcxx::ParameterList<std::integral_constant<int, 1>,
  //                         std::integral_constant<int, 2>,
  //                         std::integral_constant<int, 3>>>
  //   ([](auto wrapped)
  //     {
  //       typedef typename decltype(wrapped)::type WrappedT;
  //       wrapped.method("read", &WrappedT::read);
  //     });

  // mod.add_type<jlcxx::Parametric<jlcxx::TypeVar<1>, jlcxx::TypeVar<2>>>("AccessorWO_2d")
  // .apply_combination<legate::AccessorWO, jlcxx::ParameterList<float, double>, jlcxx::ParameterList<1,2,3,4>>([](auto wrapped)
  //   {
  //     typedef typename decltype(wrapped)::type WrappedT;
  //     wrapped.method("write", &WrappedT::read);
  //   });

  mod.method("read_double_2d", &read_double_2d);
  mod.method("write_double_2d", &write_double_2d);

  // https://github.com/nv-legate/cupynumeric/blob/5371ab3ead17c295ef05b51e2c424f62213ffd52/src/cupynumeric/ndarray.h
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
      .method("get_read_accessor_double_2d",
              &cupynumeric::NDArray::get_read_accessor<double, 2>)
      .method("get_read_accessor_float_2d",
              &cupynumeric::NDArray::get_read_accessor<float, 2>)
      .method("get_write_accessor_double_2d",
              &cupynumeric::NDArray::get_write_accessor<double, 2>)
      .method("get_write_accessor_float_2d",
              &cupynumeric::NDArray::get_write_accessor<float, 2>)
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

  //.method("add_eq", &cupynumeric::NDArray::operator+=)
  //.method("multiply_eq", &cupynumeric::NDArray::operator*=);

  mod.method("_zeros", &cupynumeric::zeros);  // operators.cc, 152
  mod.method("_full", &cupynumeric::full);    // operators.cc, 162
  mod.method("_dot", &cupynumeric::dot);      // operators.cc, 263
  mod.method("_sum", &cupynumeric::sum);      // operators.cc, 303
  // mod.method("add", &cupynumeric::add);
  // mod.method("multiply", &cupynumeric::multiply);
}