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

global TEST_PASS = false
global TEST_FAIL = true

function daxby()
N = 1000
dims = (N, N)


α_cpu = 56.6
x_cpu = zeros(dims);
y_cpu = zeros(dims);

# cunumeric arrays

# TODO 
# result = α * x + y  
# ERROR: MethodError: no method matching *(::Float64, ::cuNumeric.NDArrayAllocated)     
α = cuNumeric.full(dims, Float64(56.6))
x = cuNumeric.zeros(dims)
y = cuNumeric.zeros(dims)


for i in N
    for j in N
        x_cpu[i, j] = rand()
        y_cpu[i, j] = rand()
        # set cunumeric.jl arrays
        x[i, j] = x_cpu[i, j]
        y[i, j] = y_cpu[i, j]
    end
end


result = α * x + y

# check results 
for i in N
    for j in N
        check = (result[(i, j)] == (α_cpu * x_cpu[i, j] + y_cpu[i, j]))
        if check == 1
            #something messed up
            return TEST_FAIL
        end
    end
end

# successful completion
return TEST_PASS
end