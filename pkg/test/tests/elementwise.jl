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

#= Purpose of test: elementwise
    - [./ .- .+ .*] operators are tested
=#

function elementwise() 
seed = 10
N = 100
dims = (N, N)


arrA = cuNumeric.ones(dims)
arrA_cpu = ones(dims)
@test arrA == arrA_cpu

arrB = cuNumeric.ones(dims)
arrB_cpu = ones(dims)
@test arrB == arrB_cpu

cuNumeric.random(arrA, seed)
cuNumeric.random(arrB, seed)

arrA_cpu = arrA[:, ]
arrB_cpu = arrB[:, ]

@test arrA == arrA_cpu
@test arrB == arrB_cpu

result = cuNumeric.zeros(dims)
result_cpu = zeros(dims)
@test result == result_cpu


# where the real testing starts

# not supported yet
# arrA =  13.74 .- arrA
# arrA_cpu = 13.74 .- arrA_cpu
# @test arrA == arrA_cpu

arrA = arrA .- 13.74
arrA_cpu = arrA_cpu .- 13.74
@test arrA == arrA_cpu

result = arrA .- arrB
result_cpu = arrA_cpu .- arrB_cpu
@test result == result_cpu

result = arrA - arrB
result_cpu = arrA_cpu - arrB_cpu
@test result == result_cpu


arrA =  332.59 .+ arrA
arrA_cpu = 332.59 .+ arrA_cpu
@test arrA == arrA_cpu

arrA = arrA .+ 332.59
arrA_cpu = arrA_cpu .+ 332.59
@test arrA == arrA_cpu

result = arrA .+ arrB
result_cpu = arrA_cpu .+ arrB_cpu
@test result == result_cpu

result = arrA + arrB
result_cpu = arrA_cpu + arrB_cpu
@test result == result_cpu


# # not supported yet
# arrA = 1.3 ./ arrA 
# arrA_cpu =  1.3 ./ arrA_cpu
# @test arrA == arrA_cpu

# don't understand why this is failing
# arrA = arrA ./ 1.3
# arrA_cpu = arrA_cpu ./ 1.3
# @test arrA == arrA_cpu


result = arrA ./ arrB
result_cpu = arrA_cpu ./ arrB_cpu
@test result == result_cpu


arrA =  32.32 * arrA
arrA_cpu = 32.32 * arrA_cpu
@test arrA == arrA_cpu

arrA = arrA .* 32.32
arrA_cpu = arrA_cpu .* 32.32
@test arrA == arrA_cpu

# currently our A * B impl is element wise
result = arrA * arrB
result_cpu = arrA_cpu .* arrB_cpu
@test result == result_cpu

result = arrA .* arrB
result_cpu = arrA_cpu .* arrB_cpu
@test result == result_cpu

end