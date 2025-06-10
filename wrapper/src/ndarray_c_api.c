#include "ndarray_c_api.h"
#include "ndarray.h" 
#include "legate.h" 

#include <vector>
#include <optional>

extern "C" {

NDArray* nda_zeros_array(int32_t dim,
                         const uint64_t* shape,
                         int32_t type_code,
                         int32_t has_type)
{
  std::vector<uint64_t> shp(shape, shape + dim);
  std::optional<legate::Type> opt_type;
  if (has_type)
    opt_type = static_cast<legate::Type>(type_code);
  // call your existing factory
  NDArray result = zeros(shp, opt_type);
  // heap‐allocate a copy
  return new NDArray(std::move(result));
}

NDArray* nda_full_array(int32_t dim,
                        const uint64_t* shape,
                        double value)
{
  std::vector<uint64_t> shp(shape, shape + dim);
  Scalar s(value);
  NDArray result = full(shp, s);
  return new NDArray(std::move(result));
}

void nda_destroy_array(NDArray* arr)
{
  delete arr;
}

int32_t nda_array_dim(const NDArray* arr)
{
  return arr->dim();
}

uint64_t nda_array_size(const NDArray* arr)
{
  return arr->size();
}

int32_t nda_array_type(const NDArray* arr)
{
  return static_cast<int32_t>(arr->type());
}

void nda_array_shape(const NDArray* arr, uint64_t* out_shape)
{
  const auto& shp = arr->shape();
  for (size_t i = 0; i < shp.size(); ++i)
    out_shape[i] = shp[i];
}

} // extern "C"
