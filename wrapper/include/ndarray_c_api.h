#ifndef NDARRAY_C_API_H
#define NDARRAY_C_API_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

// Opaque handle
typedef struct NDArray NDArray;

// zeros(shape, type?)
//   dim        : number of dimensions
//   shape      : pointer to array[length=dim]
//   type_code  : integer code for legate::Type (ignored if has_type==0)
//   has_type   : 0→use default, 1→use type_code
NDArray* nda_zeros_array(int32_t dim,
                         const uint64_t* shape,
                         int32_t type_code,
                         int32_t has_type);

// full(shape, value)
//   dim   : number of dimensions
//   shape : pointer to array[length=dim]
//   value : double‐precision scalar
NDArray* nda_full_array(int32_t dim,
                        const uint64_t* shape,
                        double value);

// destroy
void     nda_destroy_array(NDArray* arr);

// simple queries
int32_t  nda_array_dim  (const NDArray* arr);
uint64_t nda_array_size (const NDArray* arr);
int32_t  nda_array_type (const NDArray* arr);

// copy out shape into user buffer (length >= dim)
void     nda_array_shape(const NDArray* arr,
                         uint64_t* out_shape);

#ifdef __cplusplus
}
#endif

#endif // NDARRAY_C_API_H
