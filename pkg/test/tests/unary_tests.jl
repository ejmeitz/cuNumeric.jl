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



function test_unary_ops()
    N = 100

    # Make Input arrays we can test on 
    julia_arr = rand(Float64, N)
    cunumeric_arr = cuNumeric.zeros(Float64, N)
    for i in 1:N
        cunumeric_arr[i] = julia_arr[i]
    end

    for base_func in keys(cuNumeric.unary_op_map)
        # Generate a function just so the test is named
        fn_name = String(Symbol(base_fun))*"_test"
        f = @eval begin 
            function $(fn_name)(jl_arr::Vector, cunum_arr::NDArray)
                cunumeric_res = base_func(cunum_arr)
                julia_res = base_func.(jl_arr)
                @test julia_res == cunumeric_res
            end
        end

        f(julia_arr, cunumeric_arr)

    end
end