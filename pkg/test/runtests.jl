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

using Test
using cuNumeric


include("tests/daxpy.jl")
include("tests/daxpy_advanced.jl")
include("tests/types_dim.jl")

@testset "This is checking 1 == 1" begin
    @test 1 == 1
end

@testset verbose = true "daxpy Tests" begin
    @testset daxpy_basic()
    @testset daxpy_advanced()
    
    @testset "types_dim" begin
        # types_dim(Float32, 1)
        # types_dim(Float32, 2)
        # types_dim(Float32, 3)
        # types_dim(Float64, 1)
        types_dim(Float64, 2)
        # types_dim(Float64, 3)
        # types_dim(Int64, 1)
        types_dim(Int64, 2)
        # types_dim(Int64, 3)
    end
end