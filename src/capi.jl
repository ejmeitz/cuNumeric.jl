const libnda = "cwarpper"    # adjust path/extension

# Opaque pointer
const NDArray_t = Ptr{Cvoid}

# zeros
function nda_zeros_array(shape::Vector{UInt64};
                         type::Union{Nothing,Int32}=nothing)
  dim = Int32(length(shape))
  has_type = isnothing(type) ? Int32(0) : Int32(1)
  type_code = has_type==1 ? type[] : Int32(0)
  ptr = ccall((:nda_zeros_array, libnda),
              NDArray_t, (Int32, Ptr{UInt64}, Int32, Int32),
              dim, shape, type_code, has_type)
  return ptr
end

# full
function nda_full_array(shape::Vector{UInt64}, value::Float64)
  dim = Int32(length(shape))
  ptr = ccall((:nda_full_array, libnda),
              NDArray_t, (Int32, Ptr{UInt64}, Float64),
              dim, shape, value)
  return ptr
end

# destroy
nda_destroy_array(arr::NDArray_t) = ccall((:nda_destroy_array, libnda),
                                         Cvoid, (NDArray_t,), arr)

# queries
nda_array_dim(arr::NDArray_t) = ccall((:nda_array_dim, libnda),
                                     Int32, (NDArray_t,), arr)
nda_array_size(arr::NDArray_t) = ccall((:nda_array_size, libnda),
                                      UInt64, (NDArray_t,), arr)
nda_array_type(arr::NDArray_t) = ccall((:nda_array_type, libnda),
                                      Int32, (NDArray_t,), arr)
function nda_array_shape(arr::NDArray_t)
  d = Int(nda_array_dim(arr))
  buf = Vector{UInt64}(undef, d)
  ccall((:nda_array_shape, libnda),
        Cvoid, (NDArray_t, Ptr{UInt64}),
        arr, buf)
  return buf
end

# --- quick smoke test ---
function test_factories()
  shp = UInt64[4,5,6]
  a = nda_zeros_array(shp)             # default type
  b = nda_zeros_array(shp, type=4)     # specify legate::Type(4)
  c = nda_full_array(shp, 3.1415)
  for x in (a,b,c)
    @show nda_array_dim(x), nda_array_size(x),
          nda_array_type(x), nda_array_shape(x)
    nda_destroy_array(x)
  end
end
