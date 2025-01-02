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

# deps/build.jl
using Pkg;
using Libdl;

env_file = joinpath(@__DIR__, "../../ENV")
@info "Sourcing environment file: $env_file"

# env script
if isfile(env_file)
    @info "Setting environment variables from $env_file"
    run(`bash -c "source $env_file && env > env.log"`)
    for line in readlines("env.log")
        key, value = split(line, "=", limit=2)
        ENV[key] = value
    end
else
    @error "Environment file not found: $env_file"
end

@info ENV["CUNUMERIC_JL_HOME"]

# patch legion. The readme below talks about our compilation error
# https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md
legion_patch = joinpath(ENV["CUNUMERIC_JL_HOME"], "scripts/patch_legion.sh")
@info "Running legion patch script: $legion_patch"
run(`bash $legion_patch`)

# build the julia cxx wrapper https://github.com/JuliaInterop/libcxxwrap-julia
build_libcxxwrap = joinpath(ENV["CUNUMERIC_JL_HOME"], "scripts/install_cxxwrap.sh")
@info "Running libcxxwrap build script: $build_libcxxwrap"
run(`bash $build_libcxxwrap`)

# create libcupynumericwrapper.so in CUNUMERIC_JL_HOME/build
build_cupynumeric_wrapper = joinpath(ENV["CUNUMERIC_JL_HOME"], "build.sh")
@info "Running cuNumeric.jl build script: $build_cupynumeric_wrapper"
run(`bash $build_cupynumeric_wrapper`)