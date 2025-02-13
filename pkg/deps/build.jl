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

import Conda
using Preferences

import Base: notnothing

function is_cupynumeric_installed(conda_env_dir::String)

    include_dir = joinpath(conda_env_dir, "include")

    if !isdir(joinpath(include_dir, "legate"))
        @error "Cannot find include/legate in $(conda_env_dir), is the right conda environment active?"
    elseif !isdir(joinpath(include_dir, "cupynumeric"))
        @error "Cannot find include/cupynumeric in $(conda_env_dir), is the right conda environment active?"
    elseif !isdir(joinpath(include_dir, "legion"))
        @error "Cannot find include/legion in $(conda_env_dir), is the right conda environment active?"
    end

    return true
end

# patch legion. The readme below talks about our compilation error
# https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md
function patch_legion(repo_root::String, conda_env_dir::String)

    @info "Patching Legion"
    @warn "This will modify your cupynumeric install"

    legion_patch = joinpath(repo_root, "scripts/patch_legion.sh")
    @info "Running legion patch script: $legion_patch"
    run(`bash $legion_patch $repo_root $conda_env_dir`)
end

function build_jlcxxwrap(repo_root)

    @info "Downloading libcxxwrap"

    cd(repo_root) do
        run(`git submodule init`)
        run(`git submodule update`)
    end

    build_libcxxwrap = joinpath(repo_root, "scripts/install_cxxwrap.sh")
    @info "Running libcxxwrap build script: $build_libcxxwrap"
    run(`bash $build_libcxxwrap $repo_root`)
end


function build_cpp_wrapper(repo_root, conda_env_dir)

    @info "Building C++ Wrapper Library"

    build_dir = joinpath(repo_root, "wrapper", "build")
    if !isdir(build_dir)
        mkdir(build_dir)
    else
        @warn "Build dir exists. Deleting prior build."
        rm(build_dir, recursive = true)
        mkdir(build_dir)
    end
    
    build_cpp_wrapper = joinpath(repo_root, "scripts/build_cpp_wrapper.sh")
    nthreads = Threads.nthreads()
    run(`bash $build_cpp_wrapper $repo_root $build_dir $conda_env_dir $nthreads`)
end

function core_build_process(conda_env_dir, run_legion_patch::Bool = true)

    repo_root = abspath(joinpath(@__DIR__, "../../"))
    @info "Parsed Repo Root as: $(repo_root)"

    # patch legion. The readme below talks about our compilation error
    # https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md
    run_legion_patch && patch_legion(repo_root, conda_env_dir)

    # We still need to build libcxxwrap from source until 
    # everything is on BinaryBuilder to ensure compiler compatability
    build_jlcxxwrap(repo_root)

    # create libcupynumericwrapper.so
    build_cpp_wrapper(repo_root, conda_env_dir)
end

function build_from_user_conda(conda_env_dir)
    is_cupynumeric_installed(conda_env_dir)
    core_build_process(conda_env_dir)
end

function build_from_julia_conda(env_name = :cupynumeric)

    conda_env_dir = Conda.prefix(env_name)

    @info "Using conda environment at : $(conda_env_dir)"

    cupynumeric_installed = is_cupynumeric_installed(conda_env_dir)

    if cupynumeric_installed
        @info "Found cupynumeric already installed."
    else
        @info "Installing cupynumeric into new conda environment"
        Conda.add_channel("conda-forge", env_name)
        Conda.add("cupynumeric", env_name, channel = "legate")
    end

    core_build_process(conda_env_dir)
end


####################################

const DEFAULT_ENV_NAME = :cupynumeric
const conda_jl_env = load_preference("cuNumeric", "conda_jl_env", DEFAULT_ENV_NAME)
const user_env = load_preference("cuNumeric", "user_env", nothing)


#* TODO PARSE CUPYNUMERIC VERSION TO DECIDE IF WE NEED TO PATCH LEGION??
#* PARSE GCC/CMAKE VERSION TO MAKE SURE ITS RECENT ENOUGH
#* MAKE SHELL SCRIPT TO RUN CMAKE COMMANDS SINCE JULIA SEEMS INCAPABLE
#* FIGURE OUT HOW TO AVOID REBUILDING JLCXXWRAPP ?

if isnothing(user_env)
    @info "User did not specify existing conda install in LocalPreferences.toml. Will use Conda.jl."
    build_from_julia_conda(conda_jl_env)
elseif notnothing(conda_jl_env) && notnothing(user_env)
    @info "User specified both a local environment and a Conda.jl environment. Will use local environment."
    build_from_user_conda(user_env)
elseif notnothing(conda_jl_env)
    @info "Using Conda.jl to install cupynumeric"
    build_from_julia_conda(conda_jl_env)
elseif notnothing(user_env)
    @info "Using local conda environment with cupynumeric."
    build_from_user_conda(user_env)
end