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

#= Purpose of test: daxby_advanced
    -- Test arbitrary types and dimensions (not done)
    -- add overloading support for [double/float scalar] * NDArray
    -- equavalence operator between a cuNumeric and Julia array without looping
    --          result == (α_cpu * x_cpu + y_cpu)
    --          (α_cpu * x_cpu + y_cpu) == result
    -- x[:, :] colon notation for reading entire NDArray to a Julia array
    -- x[:, :] colon notation for filling entire NDArray with scalar
=#
global TEST_PASS = true
global TEST_FAIL = false

function daxby_advanced()
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

    # test fill with scalar of all elements of the NDArray
    x[:, :] = 4.23

    if (x != fill(4.23, dims))
        return TEST_FAIL
    end

    # create two random arrays
    cuNumeric.random(x, seed)
    cuNumeric.random(y, seed)

    # set all the elements of each NDArray to the CPU array equivalent
    x_cpu = x[:, :]
    y_cpu = y[:, :]


    result = α * x + y

    # check results 
    if result == (α * x_cpu + y_cpu)
        # switch LHS and RHS to check different overloading
        if (α * x_cpu + y_cpu) == result
            # successful completion
            return TEST_PASS
        end
    end

    return TEST_FAIL
end