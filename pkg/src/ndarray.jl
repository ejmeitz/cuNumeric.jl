export ArrayData

#is legion Complex128 same as ComplexF64 in julia?
const primitive_type_map = Dict{Type, Int}(Bool => 0, 
                            Int8 => 1, Int16 => 2, Int32 => 3, Int64 => 4,
                            UInt8 => 5, UInt16 => 6, UInt32 => 7, UInt64 => 8, 
                            Float16 => 9, Float32 => 10, Float64 => 11,
                            ComplexF16 => 12, ComplexF32 => 13, ComplexF64 => 14)

const legate_type_fns = Dict{Int, Symbol}(
    0 => :bool_,
    1 => :int8,
    2 => :int16,
    3 => :int32,
    4 => :int64,
    5 => :uint8,
    6 => :uint16,
    7 => :uint32,
    8 => :uint64,
    9 => :float16,
    10 => :float32,
    11 => :float64,
    12 => :complex32, # COMMENTED OUT IN WRAPPER
    13 => :complex64,
    14 => :complex128
)


struct ArrayData{N,T}
    dims::StdVector{UInt64}
    type::StdOptional
end

function ArrayData(dims::NTuple{N, Integer}, type::Type = Float64) where N
    enum_idx = primitive_type_map[type]
    opt = StdOptional{LegateType}(eval(legate_type_fns[enum_idx])())
    # arr = NDArray(dims, opt)
    return ArrayData{N, type}(StdVector(UInt64.([d for d in dims])), opt);
end


function Base.:*(array1::NDArray, array2::NDArray)
    return array1.multiply(array2)
end

function Base.:+(array1::NDArray, array2::NDArray)
    return array1.add(array2)
end