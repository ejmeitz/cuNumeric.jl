#= Copyright 2025 Northwestern University,
 *                   Carnegie Mellon University University
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSEend-2.0
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

#= Purpose of test: slicing
    -- Perform NDArray operations using slices for more efficient memory access
=#

# gray scott
function slicing()
     #create new u array

    # cunumeric arrays
    N = 1000
    dims = (N, N)
    dx = 0.1
    f = 1.2
    k = 12.23

    u = cuNumeric.zeros(dims)
    v = cuNumeric.zeros(dims)

    u_new = cuNumeric.zeros(dims)
    v_new = cuNumeric.zeros(dims)
    
    #calculate F_u and F_v functions
    F_u = (-u[2:end-1, 2:end-1]*(v[2:end-1, 2:end-1] * v[2:end-1, 2:end-1])) + f*(1-u[2:end-1, 2:end-1])
    F_v = (u[2:end-1, 2:end-1]*(v[2:end-1, 2:end-1] * v[2:end-1, 2:end-1])) - (f+k)*v[2:end-1, 2:end-1]
    
    # # 2-D Laplacian of f using array slicing, excluding boundaries
    # For an N x N array f, f_lap is the Nend x Nend array in the "middle"
    u_lap = (u[3:end, 2:end-1] - 2*u[2:end-1, 2:end-1] + u[1:end-2, 2:end-1]) / dx^2 + (u[2:end-1, 3:end] - 2*u[2:end-1, 2:end-1] + u[2:end-1, 1:end-2]) / dx^2
    v_lap = (v[3:end, 1:end-1] - 2*v[2:end-1, 2:end-1] + v[1:end-2, 2:end-1]) / dx^2 + (v[2:end-1, 3:end] - 2*v[2:end-1, 2:end-1] + v[2:end-1, 1:end-2]) / dx^2

    # Forward-Euler time step for all points except the boundaries
    u_new[2:end-1, 2:end-1] = ((c_u * u_lap) + F_u)*dt + u[2:end-1, 2:end-1]
    v_new[2:end-1, 2:end-1] = ((c_v * v_lap) + F_v)*dt + v[2:end-1, 2:end-1]

    # Apply periodic boundary conditions
    u_new[:,1] = u[:,end-1]
    u_new[:,end] = u[:,2]
    u_new[1,:] = u[end-1,:]
    u_new[end,:] = u[2,:]
    v_new[:,1] = v[:,end-1]
    v_new[:,end] = v[:,2]
    v_new[1,:] = v[end-1,:]
    v_new[end,:] = v[2,:]
end   
