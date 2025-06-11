#ifndef NDARRAY_C_API_H
#define NDARRAY_C_API_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

// Opaque handle
typedef struct CN_NDArray CN_NDArray;
typedef struct CN_Type CN_Type;
typedef struct CN_Scalar CN_Scalar;

// zeros(shape, type?)
//   dim        : number of dimensions
//   shape      : pointer to array[length=dim]
//   CN_Type    : Legate type of object
CN_NDArray* nda_zeros_array(int32_t dim,
                         const uint64_t* shape,
                         CN_Type type);

// full(shape, value)
//   dim   : number of dimensions
//   shape : pointer to array[length=dim]
//   value : double‐precision scalar
CN_NDArray* nda_full_array(int32_t dim,
                        const uint64_t* shape,
                        double value);

// destroy
void     nda_destroy_array(CN_NDArray* arr);

// simple queries
int32_t  nda_array_dim  (const CN_NDArray* arr);
uint64_t nda_array_size (const CN_NDArray* arr);
int32_t  nda_array_type_code(const CN_NDArray* arr);
CN_Type* nda_array_type (const CN_NDArray* arr);

// copy out shape into user buffer (length >= dim)
void     nda_array_shape(const CN_NDArray* arr,
                         uint64_t* out_shape);

#ifdef __cplusplus
}
#endif

#endif // NDARRAY_C_API_H
