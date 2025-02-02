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
include("tests/unary_tests.jl")


@testset verbose = true "DAXPY" begin
    @testset daxpy_basic()
    @testset daxpy_advanced()
end

@testset verbose = true "SGEMM" begin
    max_diff = Float32(1e-4)
    @warn "SGEMM has some precision issues, using tol $(max_diff) 🥲"
    @testset sgemm(max_diff)
end

@testset verbose = true "Unary Ops w/o Args" begin
    N = 100
    max_diff = 1e-12

    # Make input arrays we can re-use
    julia_arr = rand(Float64, N)
    # julia_res = zeros(Float64, size(julia_arr))
    cunumeric_arr = cuNumeric.zeros(Float64, N)
    for i in 1:N
        cunumeric_arr[i] = julia_arr[i]
    end

    # julia_res = sqrt.(julia_arr)
    # cunumeric_res = sqrt(cunumeric_arr)
    # @test julia_res == cunumeric_res

    for base_func in keys(cuNumeric.unary_op_map_no_args)
        # julia_res .= base_func.(julia_arr)
        # cunumeric_res = base_func(cunumeric_arr)
        # @test cuNumeric.compare(julia_res, cunumeric_res, max_diff)

        # cunumeric_res2 = map(base_func, cunumeric_arr)
        # @test cuNumeric.compare(julia_res, cunumeric_res2, max_diff)

        # Generate a function just so the test is named
        fname = Symbol(String(Symbol(base_func))*"test")
        f = @eval begin 
            function $(fname)(jl_arr::Vector, cunum_arr::NDArray)
                cunumeric_res = $(base_func)(cunum_arr)
                julia_res = $(base_func).(jl_arr)
                return cuNumeric.compare(julia_res, cunumeric_res, $(max_diff))
            end
        end
        println(fname)
        @test f(julia_arr, cunumeric_arr)

    end
end

@testset verbose = true "Unary Ops w/ Args" begin

end

@testset verbose = true "Unary Reductions" begin
    
end