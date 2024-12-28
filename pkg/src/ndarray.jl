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


struct ArrayData{N,T}
    dims::StdVector{UInt64}
    type::StdOptional
end

function ArrayData(dims::NTuple{N, Integer}, type::Type = Float64) where N
    opt = StdOptional{LegateType}(eval(type_map[type])())
    # arr = NDArray(dims, opt)
    return ArrayData{N, type}(StdVector(UInt64.([d for d in dims])), opt);
end


function Base.:*(array1::NDArray, array2::NDArray)
    return array1.multiply(array2)
end

function Base.:+(array1::NDArray, array2::NDArray)
    return array1.add(array2)
end