#include "ndarray_c_api.h"

#include "cupynumeric.h"
#include "cupynumeric/ndarray.h" 

#include "legate.h" 

#include <vector>
#include <optional>

extern "C" {


using cupynumeric::NDArray;
using cupynumeric::zeros;
using cupynumeric::full;
using legate::Scalar;


struct CN_NDArray {
  NDArray obj;
};

struct CN_Type {
  legate::Type obj;
};


legate::Type code_to_type(legate::Type::Code code) {
  switch (code) {
    case legate::Type::Code::BOOL:       return legate::bool_();
    case legate::Type::Code::INT8:       return legate::int8();
    case legate::Type::Code::INT16:      return legate::int16();
    case legate::Type::Code::INT32:      return legate::int32();
    case legate::Type::Code::INT64:      return legate::int64();
    case legate::Type::Code::UINT8:      return legate::uint8();
    case legate::Type::Code::UINT16:     return legate::uint16();
    case legate::Type::Code::UINT32:     return legate::uint32();
    case legate::Type::Code::UINT64:     return legate::uint64();
    case legate::Type::Code::FLOAT16:    return legate::float16();
    case legate::Type::Code::FLOAT32:    return legate::float32();
    case legate::Type::Code::FLOAT64:    return legate::float64();
    case legate::Type::Code::COMPLEX64:  return legate::complex64();
    case legate::Type::Code::COMPLEX128: return legate::complex128();
    default:
      throw std::runtime_error("Unknown type code");
  }
}

CN_NDArray* nda_zeros_array(int32_t dim,
                         const uint64_t* shape,
                         CN_Type type)
{
  std::vector<uint64_t> shp(shape, shape + dim);
  // call your existing factory
  NDArray result = zeros(shp, type.obj);
  // heap‐allocate a copy
  return new CN_NDArray{NDArray(std::move(result))};
}

CN_NDArray* nda_full_array(int32_t dim,
                        const uint64_t* shape,
                        double value)
{
  std::vector<uint64_t> shp(shape, shape + dim);
  Scalar s(value);
  NDArray result = full(shp, s);
  return new CN_NDArray{NDArray(std::move(result))};
}

void nda_destroy_array(CN_NDArray* arr)
{
  delete arr;
}

int32_t nda_array_dim(const CN_NDArray* arr)
{
  return arr->obj.dim();
}

uint64_t nda_array_size(const CN_NDArray* arr)
{
  return arr->obj.size();
}

int32_t nda_array_type_code(const CN_NDArray* arr)
{
  return static_cast<int32_t>(arr->obj.type().code());
}

CN_Type* nda_array_type(const CN_NDArray* arr)
{
  return new CN_Type{arr->obj.type()};
}

void nda_array_shape(const CN_NDArray* arr, uint64_t* out_shape)
{
  const auto& shp = arr->obj.shape();
  for (size_t i = 0; i < shp.size(); ++i)
    out_shape[i] = shp[i];
}

} // extern "C"
