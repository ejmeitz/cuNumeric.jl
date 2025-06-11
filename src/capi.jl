export test_factories

lib = "libcwrapper.so"
libnda = joinpath(@__DIR__, "../", "wrapper", "build", lib)

# Opaque pointer
const NDArray_t = Ptr{Cvoid}

# destroy
nda_destroy_array(arr::NDArray_t) = ccall((:nda_destroy_array, libnda),
                                         Cvoid, (NDArray_t,), arr)

mutable struct NDHandle
  ptr::NDArray_t
  function NDHandle(ptr)
    handle = new(ptr)
    finalizer(handle) do h
        cuNumeric.nda_destroy_array(h.ptr)
    end
    return handle
  end
end

# zeros
function nda_zeros_array(shape::Vector{UInt64}; type::Union{Nothing, Type{T}} = nothing) where T
  dim = Int32(length(shape))
  legate_type = Legate.to_legate_type(isnothing(type) ? Float64 : type)
  ptr = ccall((:nda_zeros_array, libnda),
              NDArray_t, (Int32, Ptr{UInt64}, Legate.LegateTypeAllocated),
              dim, shape, legate_type)
  handle = NDHandle(ptr)
  return handle
end

# full
function nda_full_array(shape::Vector{UInt64}, value::Float64)
  dim = Int32(length(shape))
  ptr = ccall((:nda_full_array, libnda),
              NDArray_t, (Int32, Ptr{UInt64}, Float64),
              dim, shape, value)
  handle = NDHandle(ptr)
  return handle
end

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
  a = nda_zeros_array(shp)                 # default type
  b = nda_zeros_array(shp, type=Float64)  
  c = nda_full_array(shp, 3.1415)
  for x in (a,b,c)
    @show nda_array_dim(x), nda_array_size(x),
          nda_array_type(x), nda_array_shape(x)
    nda_destroy_array(x)
  end
end
