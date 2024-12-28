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


struct ArrayDesc{N,T}
    dims::StdVector{UInt64}
    type::StdOptional
end

function ArrayDesc(dims::NTuple{N, Integer}, type::Type = Float64) where N
    opt = StdOptional{LegateType}(eval(type_map[type])())
    # arr = NDArray(dims, opt)
    return ArrayDesc{N, type}(StdVector(UInt64.([d for d in dims])), opt);
end


function Base.:*(array1::NDArray, array2::NDArray)
    return array1.multiply(array2)
end

function Base.:+(array1::NDArray, array2::NDArray)
    return array1.add(array2)
end