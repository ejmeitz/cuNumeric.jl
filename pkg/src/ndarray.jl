export ArrayData

#is legion Complex128 same as ComplexF64 in julia?
const type_map = Dict{Type, Symbol}(
    Bool => :bool_, 
    Int8 => :int8,
    Int16 => :int16,
    Int32 => :int32,
    Int64 => :int64,
    UInt8 => :uint8,
    UInt16 => :uint16,
    UInt32 => :uint32, 
    UInt64 => :uint64, 
    Float16 => :float16, 
    Float32 => :float32, 
    Float64 => :float64,
    ComplexF16 => :complex32,  #COMMENTED OUT IN WRAPPER
    ComplexF32 => :complex64, 
    ComplexF64 => :complex128
)


# struct ArrayData{N,T}
#     dims::StdVector{UInt64}
#     type::StdOptional
# end

# function ArrayData(dims::NTuple{N, Integer}, type::Type = Float64) where N
#     opt = StdOptional{LegateType}(eval(type_map[type])())
#     # arr = NDArray(dims, opt)
#     return ArrayData{N, type}(StdVector(UInt64.([d for d in dims])), opt);
# end

#probably some way to enforce this only gets passed int types
to_cpp_dims(dims::Dims{N}, int_type::Type = UInt64) where N = StdVector(int_type.([d for d in dims]))

function zeros(dims::Dims{N}, type::Type = Float64) where N
    opt = StdOptional{LegateType}(eval(type_map[type])())
    dims_uint64 = to_cpp_dims(dims)
    return zeros(dims_uint64, opt) #rename wrapper to avoid confusion?
end

function full(dims::Dims{N}, val::Union{Float32, Float64}) where N
    dims_uint64 = to_cpp_dims(dims)
    return full(dims_uint64, LegateScalar(val))
end

function Base.:*(arr1::NDArray, arr2::NDArray)
    return multiply(arr1, arr2)
end

function Base.:+(arr1::NDArray, arr2::NDArray)
    return add(arr1,arr2)
end

#* not sure the out arr can be same as input array
# function Base.:+=(lhs::NDArray, rhs::NDArray)
#     return add(lhs, rhs, StdOptional{NDArray}(lhs)) 
# end