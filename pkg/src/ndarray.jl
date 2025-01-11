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

# is legion Complex128 same as ComplexF64 in julia? 
# These are methods that return a Legate::Type
global const type_map = Dict{Type, Symbol}(
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

global const code_type_map = Dict{TypeCode, Type}(
    cuNumeric.BOOL => Bool,
    cuNumeric.INT8 => Int8,
    cuNumeric.INT16 => Int16,
    cuNumeric.INT32 => Int32,
    cuNumeric.INT64 => Int64,
    cuNumeric.UINT8 => UInt8,
    cuNumeric.UINT16 => UInt16,
    cuNumeric.UINT32 => UInt32,
    cuNumeric.UINT64 => UInt64,
    cuNumeric.FLOAT16 => Float16,
    cuNumeric.FLOAT32 => Float32,
    cuNumeric.FLOAT64 => Float64,
    cuNumeric.COMPLEX64 => ComplexF32,
    cuNumeric.COMPLEX128 => ComplexF64,
    cuNumeric.STRING => String # CxxString?
)

#probably some way to enforce this only gets passed int types
to_cpp_dims(dims::Dims{N}, int_type::Type = UInt64) where N = StdVector(int_type.([d for d in dims]))
to_cpp_dims_int(dims::Dims{N}, int_type::Type = Int64) where N = StdVector(int_type.([d for d in dims]))
to_cpp_dims_int(d::Int64, int_type::Type = Int64) = StdVector(int_type.([d]))

#julia is 1 indexed vs c is 0 indexed. added the -1 
to_cpp_index(idx::Dims{N}, int_type::Type = UInt64) where N = StdVector(int_type.([e - 1 for e in idx]))
to_cpp_index(d::Int64, int_type::Type = UInt64) = StdVector(int_type.([d - 1]))


function zeros(dims::Dims{N}, type::Type = Float64) where N
    opt = StdOptional{LegateType}(eval(type_map[type])())
    dims_uint64 = to_cpp_dims(dims)
    return _zeros(dims_uint64, opt)
end

function full(dims::Dims{N}, val::Union{Float32, Float64}) where N
    dims_uint64 = to_cpp_dims(dims)
    return _full(dims_uint64, LegateScalar(val))
end

function reshape(arr::NDArray, i::Dims{N}) where N
    i_int64 = to_cpp_dims_int(i)
    return _reshape(arr, i_int64)
end

function reshape(arr::NDArray, i::Int64)
    i_int64 = to_cpp_dims_int(i)
    return _reshape(arr, i_int64)
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



function Base.getindex(arr::NDArray, idxs::Vararg{Int, N}) where N
    T = code_type_map[code(type(arr))]
    acc = NDArrayAccessor{T,N}()
    return read(acc, arr, to_cpp_index(idxs))
end


function Base.setindex!(arr::NDArray, value::T, idxs::Vararg{Int, N}) where {T <: Number, N}
    acc = NDArrayAccessor{T,N}()
    write(acc, arr, to_cpp_index(idxs), value)
end


function Base.getindex(arr::NDArray, rows::Colon, cols::Colon)
    # TODO this only works on 2D arrays
    # Flatten array NDAray.flat() ?
    # Maybe use Legion PointInRect iterator ?

    arr_dims = cuNumeric.shape(arr)
    nrows = Int64(arr_dims[1])
    ncols = Int64(arr_dims[2])

    julia_array = Base.zeros((nrows, ncols))
    for i in 1:nrows
        for j in 1:ncols
            julia_array[i, j] = arr[i, j]
        end
    end
    return julia_array
end


function Base.getindex(arr::NDArray, e::Colon)
    elems = Int64(cuNumeric.size(arr));
    julia_array = Base.zeros(elems)
    for i in 1:elems
        julia_array[i] = arr[i]
    end
    return julia_array
end


# arr[:] = value
function Base.setindex!(arr::NDArray, value::Union{Float32, Float64}, c::Colon)
    fill(arr, LegateScalar(value))
end

# arr[:, :] = value
function Base.setindex!(arr::NDArray, value::Union{Float32, Float64}, c1::Colon, c2::Colon)
    fill(arr, LegateScalar(value))
end

# arr1 == arr2
function Base.:(==)(arr1::NDArray, arr2::NDArray)
    # TODO this only works on 2D arrays
    # should we use a lazy hashing approach? 
    # something like this? would this be better than looping thru the elements?
    # hash(arr1.data) == hash(arr2.data)
    if (cuNumeric.dim(arr1) != cuNumeric.dim(arr2))
        return false
    end

    if(cuNumeric.dim(arr1) >= 3)
        return false
    end

    dim_array = cuNumeric.dim(arr1) 
    if(dim_array == 1)
        if (cuNumeric.size(arr1) != cuNumeric.size(arr2))
            printstyled("WARNING: left NDArray is $size(arr1) and right NDArray array is $(size(arr1))!\n", color=:yellow, bold=true)
            return false
        end
        
        for i in 1:size(arr1)
            if arr1[i] != arr2[i]
                # not equal
                return false
            end
        end


    elseif(dim_array == 2)
        arr1_dims = cuNumeric.shape(arr1)
        arr2_dims = cuNumeric.shape(arr2)

        if (cuNumeric.size(arr1) != cuNumeric.size(arr2))
            printstyled("WARNING: left NDArray is $(arr1_dims[1]) by $(arr1_dims[2]) and right NDArray array is $(arr2_dims[1]) by $(arr2_dims[2])!\n", color=:yellow, bold=true)
            return false
        end
        
        nrows = Int64(arr1_dims[1])
        ncols = Int64(arr1_dims[2])

        for i in 1:nrows
            for j in 1:ncols
                if arr1[i, j] != arr2[i, j]
                    # not equal
                    return false
                end
            end
        end
    end
    # successful completion
    return true
end

# arr == julia_array
function Base.:(==)(arr::NDArray, julia_array::Matrix)
    if (cuNumeric.size(arr) != prod(Base.size(julia_array)))
        printstyled("WARNING: left NDArray is $(cuNumeric.size(arr)) and right Julia array is $(prod(Base.size(julia_array)))!\n", color=:yellow, bold=true)
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



# arr == julia_array
function Base.:(==)(arr::NDArray, julia_array::Vector)
    elems = Int64(cuNumeric.size(arr));
    if (elems != prod(Base.size(julia_array)))
        printstyled("WARNING: left NDArray is $(elems) and right Julia array is $(prod(Base.size(julia_array)))!\n", color=:yellow, bold=true)
        return false
    end
    
    for i in 1:elems
        if arr[i] != julia_array[i]
            # not equal
            return false
        end
    end
    return true    
end


# julia_array == arr
function Base.:(==)(julia_array::Matrix, arr::NDArray)
    # flip LHS and RHS
    return (arr == julia_array)
end

# julia_array == arr
function Base.:(==)(julia_array::Vector, arr::NDArray)
    # flip LHS and RHS
    return (arr == julia_array)
end


#* not sure the out arr can be same as input array
# function Base.:+=(lhs::NDArray, rhs::NDArray)
#     return add(lhs, rhs, StdOptional{NDArray}(lhs)) 
# end