
// cuPyNumeric C++ API
// https://github.com/nv-legate/cupynumeric/blob/branch-24.11/src/cupynumeric/operators.h

// legate::Type defined here:
// https://github.com/nv-legate/legate/blob/main/src/core/type/type_info.h
// can find inside of conda here:
// /home/emeitz/.conda/envs/cunumeric/include/legate/legate/type/type_info.h

#include "jlcxx/jlcxx.hpp"
#include "cupynumeric/cupynumeric/operators.h"
#include "cupynumeric/cupynumeric/ndarray.h"
#include "legate/legate/type/type_info.h"
#include "legate/legate/data/logical_store.h"
#include "legate/legate/utilities/internal_shared_ptr.h"



JLCXX_MODULE define_julia_module(jlcxx::Module& mod)
{

    mod.add_type<legate::Type>("LegateType"); // this is a base class
    mod.add_type<legate::PrimitiveType>("LegatePrimitiveType", jlcxx::julia_base_type<legate::Type>())
        .constructor<int32_t>(); // write map in Julia lib that hard codes the mapping to the codes below


    mod.add_type<legate::detail::LogicalStore>("LogicalStore")

    //& create Runtime Object and add create_store 


    //can reate logical store from Runtime with create_store
    // then can create NDArray from logical store and call ops


    mod.add_type<NDArray>("NDArray")
        .constructor<legate::LogicalStore>()
        .method("dim", &NDArray::dim)
        .method("size", &NDArray::size)
        .method("dot", &NDArray::dot)
        .method("binary_op", &NDArray::binary_op)



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
//     FLOAT32     = FLOAT32_LT,     /*!< Single-precision floating point type */
//     FLOAT64     = FLOAT64_LT,     /*!< Double-precision floating point type */
//     COMPLEX64   = COMPLEX64_LT,   /*!< Single-precision complex type */
//     COMPLEX128  = COMPLEX128_LT,  /*!< Double-precision complex type */
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