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

#= Purpose of test: types_dim
    runtests will call types_dim multiple times varying the Type and # of dims
=#
function types_dim(T::Type, dim)
    if dim == 1
        dims = (10000)
    elseif dim == 2
        dims = (100, 100)
    elseif dim == 3
        dims = (10, 10, 10)
    end

    seed = 10

    α = T(56)
    
    x_cpu = Base.zeros(T, dims);
    y_cpu = Base.zeros(T, dims);

    x = cuNumeric.zeros(dims, T)
    y = cuNumeric.zeros(dims, T)

    cuNumeric.random(x, seed)
    cuNumeric.random(y, seed)

    x_cpu = x[:, :]
    y_cpu = y[:, :]

    result = α * x + y

    @test result == (α * x_cpu + y_cpu)
end