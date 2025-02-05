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
using Pkg
using Libdl

repo_root = abspath(joinpath(@__DIR__, "../../"))
@info "Parsed Repo Root as: $(repo_root)"


if !haskey(ENV, "CONDA_PREFIX")
    @error "CONDA_PREFIX environment variable is not set. Build process assumes cupynumeric is installed in the active conda environment."
end

# Quick sanity check to ensure this conda environment
# probably has the right files installed before
# we get too far.
conda_env_dir = ENV["CONDA_PREFIX"]
conda_include = joinpath(conda_env_dir, "include")

if !isdir(joinpath(conda_include, "legate"))
    @error "Cannot find include/legate in $(conda_env_dir), is the right conda environment active?"
elseif !isdir(joinpath(conda_include, "cupynumeric"))
    @error "Cannot find include/cupynumeric in $(conda_env_dir), is the right conda environment active?"
elseif !isdir(joinpath(conda_include, "legion"))
    @error "Cannot find include/legion in $(conda_env_dir), is the right conda environment active?"
end



# patch legion. The readme below talks about our compilation error
# https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md
legion_patch = joinpath(repo_root, "scripts/patch_legion.sh")
@info "Running legion patch script: $legion_patch"
run(`bash $legion_patch $repo_root`)


# We still need to build libcxxwrap from source until 
# everything is on BinaryBuilder to ensure compiler compatability

@info "Downloading libcxxwrap"
cd(repo_root) do
    run(`git submodule init`)
    run(`git submodule update`)
end

build_libcxxwrap = joinpath(repo_root, "scripts/install_cxxwrap.sh")
@info "Running libcxxwrap build script: $build_libcxxwrap"
run(`bash $build_libcxxwrap $repo_root`)

# create libcupynumericwrapper.so in CUNUMERIC_JL_HOME/build
build_dir = joinpath(repo_root, "wrapper", "build")
if !isdir(build_dir)
    mkdir(build_dir)
else
    @warn "Build dir exists. Deleting prior build."
    rm(build_dir, recursive = true)
    mkdir(build_dir)
end

build_cmd = Cmd(`cmake -S $repo_root -B $build_dir`; env = Dict("CMAKE_PREFIX_PATH" => conda_env_dir))
run(build_cmd)
run(`cmake --build $repo_root/build --parallel $(Threads.nthreads()) --verbose`)
