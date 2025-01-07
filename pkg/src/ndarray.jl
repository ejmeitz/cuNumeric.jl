#= Copyright 2025 Northwestern University, 
 *                   Carnegie Mellon University University
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Author(s): David Krasowska <krasow@u.northwestern.edu>
 *            Ethan Meitz <emeitz@andrew.cmu.edu>
=#
export ArrayDesc

# is legion Complex128 same as ComplexF64 in julia? 
# These are methods that return a LegateTypeAllocated
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
    # ComplexF16 => :complex32,  #COMMENTED OUT IN WRAPPER
    ComplexF32 => :complex64, 
    ComplexF64 => :complex128
)

const type_code_map = Dict{Int32, Type}(
    LEGION_TYPE_BOOL => Bool,
    LEGION_TYPE_INT8 => Int8,
    LEGION_TYPE_INT16 => Int16,
    LEGION_TYPE_INT32 => Int32,
    LEGION_TYPE_INT64 => Int64,
    LEGION_TYPE_UINT8 => UInt8,
    LEGION_TYPE_UINT16 => UInt16,
    LEGION_TYPE_UINT32 => UInt32,
    LEGION_TYPE_UINT64 => UInt64,
    LEGION_TYPE_FLOAT16 => Float16,
    LEGION_TYPE_FLOAT32 => Float32,
    LEGION_TYPE_FLOAT64 => Float64,
    LEGION_TYPE_COMPLEX64 => ComplexF32,
    LEGION_TYPE_COMPLEX128 => ComplexF64,
    # has different type than the rest cause its just an int in the enum
    # cuNumeric.STRING => String
)

#probably some way to enforce this only gets passed int types
to_cpp_dims(dims::Dims{N}, int_type::Type = UInt64) where N = StdVector(int_type.([d for d in dims]))
#julia is 1 indexed vs c is 0 indexed. added the -1 
to_cpp_index(idx::Dims{N}, int_type::Type = UInt64) where N = StdVector(int_type.([e - 1 for e in idx]))

function zeros(dims::Dims{N}, type::Type = Float64) where N
    opt = StdOptional{LegateType}(eval(type_map[type])())
    dims_uint64 = to_cpp_dims(dims)
    return _zeros(dims_uint64, opt)
end

function full(dims::Dims{N}, val::Union{Float32, Float64}) where N
    dims_uint64 = to_cpp_dims(dims)
    return _full(dims_uint64, LegateScalar(val))
end

function Base.:*(arr1::NDArray, arr2::NDArray)
    return multiply(arr1, arr2)
end

function Base.:+(arr1::NDArray, arr2::NDArray)
    return add(arr1, arr2)
end

function Base.:+(val::Union{Float32, Float64}, arr::NDArray)
    return add_scalar(arr, LegateScalar(val))
end

function Base.:*(val::Union{Float32, Float64}, arr::NDArray)
    return multiply_scalar(arr, LegateScalar(val))
end


# function Base.getindex(arr::NDArray, idxs::Vararg{Int, N}) where N
#     T = legion_type_map[code(type(arr))]
#     acc = get_read_accessor(arr, AccessorTypeContainer{T, N}())
#     return read(acc, to_cpp_index(tuple(idxs...))) #* this probably allocates the tuple
# end

function Base.getindex(arr::NDArray, i::Dims{N}) where N
    T = type_code_map[code(cuNumeric.type(arr))]
    acc = NDArrayAccessor{T,N}()
    return read(acc, arr, to_cpp_index(i)) #* this probably allocates the tuple
end


function Base.getindex(arr::NDArray, i::Int64, j::Int64)
    T = type_code_map[code(cuNumeric.type(arr))]
    acc = NDArrayAccessor{T,N}()
    return read(acc, arr, to_cpp_index((i, j)))
end


# function Base.setindex!(arr::NDArray, value::T, idxs::Vararg{Int, N}) where {T <: Number, N}
#     acc = get_write_accessor(arr, AccessorTypeContainer{T, N}())
#     write(acc, to_cpp_index(tuple(idxs...)), value) #* this probably allocates the tuple
# end

function Base.setindex!(arr::NDArray, value::T, i::Dims{N}) where {T <: Number, N}
    acc = NDArrayAccessor{T,N}()
    write(acc, arr, to_cpp_index(i), value) #* this probably allocates the tuple
end


function Base.setindex!(arr::NDArray, value::T, i::Int64, j::Int64) where {T <: Number}
    acc = NDArrayAccessor{T,2}()
    write(acc, arr, to_cpp_index((i, j)), value)
end


function Base.getindex(arr::NDArray, rows::Colon, cols::Colon)
    # TODO fix temp hardcoded solution
    nrows = 100
    ncols = 100
    

    julia_array = Base.zeros((nrows, ncols))
    for i in 1:nrows
        for j in 1:ncols
            julia_array[i, j] = arr[i, j]
        end
    end
    return julia_array
end


function Base.setindex!(arr::NDArray, value::Union{Float32, Float64}, rows::Colon, cols::Colon)
    fill(arr, LegateScalar(value))
end


function Base.:(==)(arr::NDArray, julia_array::Matrix)
    if (cuNumeric.size(arr) != prod(Base.size(julia_array)))
        printstyled("WARNING: left NDArray is $(cuNumeric.size(arr)) and right Julia array is $(Base.size(julia_array))!\n", color=:yellow, bold=true)
        return false
    end
    
    for i in 1:Base.size(julia_array, 1)
        for j in 1:Base.size(julia_array, 2)
            if arr[i, j] != julia_array[i, j]
                # not equal
                return false
            end
        end
    end

    # successful completion
    return true
end



function Base.:(==)(julia_array::Matrix, arr::NDArray)
    # flip LHS and RHS
    return (arr == julia_array)
end


#* not sure the out arr can be same as input array
# function Base.:+=(lhs::NDArray, rhs::NDArray)
#     return add(lhs, rhs, StdOptional{NDArray}(lhs)) 
# end