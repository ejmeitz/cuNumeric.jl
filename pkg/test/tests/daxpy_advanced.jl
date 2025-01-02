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

#= Purpose of test: daxpy_advanced
    -- add overloading support for [double/float scalar] * NDArray
    -- equavalence operator between a cuNumeric and Julia array without looping
    --          result == (α_cpu * x_cpu + y_cpu)
    --          (α_cpu * x_cpu + y_cpu) == 
    -- NDArray copy method allocates a new NDArray and copies all elements
    -- x[:, :] colon notation for reading entire NDArray to a Julia array
    -- x[:, :] colon notation for filling entire NDArray with scalar
=#

function daxpy_advanced()
    seed = 10

    N = 100
    dims = (N, N)

    α = 56.6

    # base Julia arrays
    x_cpu = zeros(dims);
    y_cpu = zeros(dims);

    # cunumeric arrays
    x = cuNumeric.zeros(dims)
    y = cuNumeric.zeros(dims)

    @test x_cpu == x
    @test y_cpu == y
    @test x == x_cpu # LHS and RHS are switched
    @test y == y_cpu

    # test fill with scalar of all elements of the NDArray
    x[:, :] = 4.23
    
    @test x == fill(4.23, dims)
     
    # create two random arrays
    cuNumeric.random(x, seed)
    cuNumeric.random(y, seed)

    # create a reference of NDArray
    x_ref = x
    y_ref = y
    @test x_ref == x
    @test y_ref == y

    # create a copy of NDArray
    x_copy = copy(x)
    y_copy = copy(y)
    @test x_copy == x
    @test y_copy == y

    # set all the elements of each NDArray to the CPU array equivalent
    x_cpu = x[:, :]
    y_cpu = y[:, :]

    result = α * x + y

    # check results 
    @test result == (α * x_cpu + y_cpu)
    @test (α * x_cpu + y_cpu) == result # LHS and RHS switched

    nothing
end