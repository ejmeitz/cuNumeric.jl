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
using LinearAlgebra


include("tests/daxpy.jl")
include("tests/daxpy_advanced.jl")
include("tests/sgemm.jl")


@testset verbose = true "daxpy Tests" begin
    @testset daxpy_basic()
    @testset daxpy_advanced()
end

@testset verbose = true "MatMulTests" begin
    @warn "SGEMM has some precision issue 🥲"
    max_diff = Float32(1e-4)
    @testset sgemm(max_diff)
end