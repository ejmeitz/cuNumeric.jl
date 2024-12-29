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

JLCXX_MODULE define_julia_module(jlcxx::Module& mod) {
  // These are used in stencil.cc, seem important
  mod.method("start_legate", &legate::start);  // no idea where this is
  mod.method("initialize_cunumeric", &cupynumeric::initialize);  // runtime.cc
  mod.method("legate_finish", &legate::finish);  // no idea where this is

    mod.add_bits<legion_type_id_t>("LegionType", jlcxx::julia_type("CppEnum"));
    mod.set_const("LEGION_TYPE_BOOL",     0);
    mod.set_const("LEGION_TYPE_INT8",     1);
    mod.set_const("LEGION_TYPE_INT16",    2);
    mod.set_const("LEGION_TYPE_INT32",    3);
    mod.set_const("LEGION_TYPE_INT64",    4);
    mod.set_const("LEGION_TYPE_UINT8",    5);
    mod.set_const("LEGION_TYPE_UINT16",   6);
    mod.set_const("LEGION_TYPE_UINT32",   7);
    mod.set_const("LEGION_TYPE_UINT64",   8);
    mod.set_const("LEGION_TYPE_FLOAT16",  9);
    mod.set_const("LEGION_TYPE_FLOAT32",  10);
    mod.set_const("LEGION_TYPE_FLOAT64",  11);
    mod.set_const("LEGION_TYPE_COMPLEX32",   12);
    mod.set_const("LEGION_TYPE_COMPLEX64",   13);
    mod.set_const("LEGION_TYPE_COMPLEX128",  14);
    mod.set_const("LEGION_TYPE_TOTAL", 15);

    mod.add_bits<legate::Type::Code>("TypeCode", jlcxx::julia_type("CppEnum"));
    mod.set_const("BOOL",     legion_type_id_t::LEGION_TYPE_BOOL);
    mod.set_const("INT8",     legion_type_id_t::LEGION_TYPE_INT8);
    mod.set_const("INT16",    legion_type_id_t::LEGION_TYPE_INT16);
    mod.set_const("INT32",    legion_type_id_t::LEGION_TYPE_INT32);
    mod.set_const("INT64",    legion_type_id_t::LEGION_TYPE_INT64);
    mod.set_const("UINT8",    legion_type_id_t::LEGION_TYPE_UINT8);
    mod.set_const("UINT16",   legion_type_id_t::LEGION_TYPE_UINT16);
    mod.set_const("UINT32",   legion_type_id_t::LEGION_TYPE_UINT32);
    mod.set_const("UINT64",   legion_type_id_t::LEGION_TYPE_UINT64);
    mod.set_const("FLOAT16",  legion_type_id_t::LEGION_TYPE_FLOAT16);
    mod.set_const("FLOAT32",  legion_type_id_t::LEGION_TYPE_FLOAT32);
    mod.set_const("FLOAT64",  legion_type_id_t::LEGION_TYPE_FLOAT64);
    mod.set_const("COMPLEX64",    legion_type_id_t::LEGION_TYPE_COMPLEX64);
    mod.set_const("COMPLEX128",   legion_type_id_t::LEGION_TYPE_COMPLEX128);
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

    //in scalar.h
    mod.add_type<legate::Scalar>("LegateScalar")
        .constructor<float>()
        .constructor<double>(); //julia lets me make with ints???

// https://github.com/nv-legate/cupynumeric/blob/5371ab3ead17c295ef05b51e2c424f62213ffd52/src/cupynumeric/ndarray.h       
    mod.add_type<cupynumeric::NDArray>("NDArray")
        .method("dim", &cupynumeric::NDArray::dim)
        .method("size", &cupynumeric::NDArray::size)
        .method("type", &cupynumeric::NDArray::type)
        .method("as_type", &cupynumeric::NDArray::as_type)
        .method("binary_op", &cupynumeric::NDArray::binary_op)
        .method("get_store", &cupynumeric::NDArray::get_store)
	    .method("add", (cupynumeric::NDArray (cupynumeric::NDArray::*)(const cupynumeric::NDArray&) const) &cupynumeric::NDArray::operator+)	
	    .method("multiply",  (cupynumeric::NDArray (cupynumeric::NDArray::*)(const cupynumeric::NDArray&) const) &cupynumeric::NDArray::operator*);

	//.method("add_eq", &cupynumeric::NDArray::operator+=)
	//.method("multiply_eq", &cupynumeric::NDArray::operator*=);

    mod.method("zeros", &cupynumeric::zeros); // operators.cc, 152
    mod.method("full", &cupynumeric::full); // operators.cc, 162
    mod.method("dot", &cupynumeric::dot); //operators.cc, 263
    mod.method("sum", &cupynumeric::sum); //operators.cc, 303
    // mod.method("add", &cupynumeric::add);
    // mod.method("multiply", &cupynumeric::multiply);
}


// These codes map to this enum
// https://github.com/nv-legate/legate/blob/fd4563612c9ebc8d342d88ce790da6cc9b311cdf/src/core/legate_c.h#L76C1-L98C27
// which map to the legion/legion_config.h here:
// https://github.com/StanfordLegion/legion/blob/4a03402467547b99530042cfe234ceec2cd31b2e/runtime/legion/legion_config.h#L1627

// enum class Code : int32_t {
//     BOOL        = BOOL_LT,        /*!< Boolean type */
//     INT8        = INT8_LT,        /*!< 8-bit signed integer type */
//     INT16       = INT16_LT,       /*!< 16-bit signed integer type */
//     INT32       = INT32_LT,       /*!< 32-bit signed integer type */
//     INT64       = INT64_LT,       /*!< 64-bit signed integer type */
//     UINT8       = UINT8_LT,       /*!< 8-bit unsigned integer type */
//     UINT16      = UINT16_LT,      /*!< 16-bit unsigned integer type */
//     UINT32      = UINT32_LT,      /*!< 32-bit unsigned integer type */
//     UINT64      = UINT64_LT,      /*!< 64-bit unsigned integer type */
//     FLOAT16     = FLOAT16_LT,     /*!< Half-precision floating point type */
//     FLOAT32     = FLOAT32_LT,     /*!< Single-precision floating point type
//     */ FLOAT64     = FLOAT64_LT,     /*!< Double-precision floating point
//     type */ COMPLEX64   = COMPLEX64_LT,   /*!< Single-precision complex type
//     */ COMPLEX128  = COMPLEX128_LT,  /*!< Double-precision complex type */
//     FIXED_ARRAY = FIXED_ARRAY_LT, /*!< Fixed-size array type */
//     STRUCT      = STRUCT_LT,      /*!< Struct type */
//     STRING      = STRING_LT,      /*!< String type */
//     INVALID     = INVALID_LT,     /*!< Invalid type */
//   };

// typedef enum legate_core_type_code_t {
//   // Buil-in primitive types
//   BOOL_LT       = LEGION_TYPE_BOOL,
//   INT8_LT       = LEGION_TYPE_INT8,
//   INT16_LT      = LEGION_TYPE_INT16,
//   INT32_LT      = LEGION_TYPE_INT32,
//   INT64_LT      = LEGION_TYPE_INT64,
//   UINT8_LT      = LEGION_TYPE_UINT8,
//   UINT16_LT     = LEGION_TYPE_UINT16,
//   UINT32_LT     = LEGION_TYPE_UINT32,
//   UINT64_LT     = LEGION_TYPE_UINT64,
//   FLOAT16_LT    = LEGION_TYPE_FLOAT16,
//   FLOAT32_LT    = LEGION_TYPE_FLOAT32,
//   FLOAT64_LT    = LEGION_TYPE_FLOAT64,
//   COMPLEX64_LT  = LEGION_TYPE_COMPLEX64,
//   COMPLEX128_LT = LEGION_TYPE_COMPLEX128,
//   // Compound types
//   FIXED_ARRAY_LT,
//   STRUCT_LT,
//   // Variable size types
//   STRING_LT,
//   INVALID_LT = -1,
// } legate_core_type_code_t;

// typedef enum legion_type_id_t {
//   LEGION_TYPE_BOOL = 0,
//   LEGION_TYPE_INT8 = 1,
//   LEGION_TYPE_INT16 = 2,
//   LEGION_TYPE_INT32 = 3,
//   LEGION_TYPE_INT64 = 4,
//   LEGION_TYPE_UINT8 = 5,
//   LEGION_TYPE_UINT16 = 6,
//   LEGION_TYPE_UINT32 = 7,
//   LEGION_TYPE_UINT64 = 8,
//   LEGION_TYPE_FLOAT16 = 9,
//   LEGION_TYPE_FLOAT32 = 10,
//   LEGION_TYPE_FLOAT64 = 11,
//   LEGION_TYPE_COMPLEX32 = 12,
//   LEGION_TYPE_COMPLEX64 = 13,
//   LEGION_TYPE_COMPLEX128 = 14,
//   LEGION_TYPE_TOTAL = 15, // must be last
// } legion_type_id_t;
