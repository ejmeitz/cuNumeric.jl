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

using Pkg
import Base: notnothing

import Conda
using Preferences
# import CNPreferences

const SUPPORTED_CUPYNUMERIC_VERSIONS = ["25.03", "25.03.01"]
const LATEST_CUPYNUMERIC_VERSION = SUPPORTED_CUPYNUMERIC_VERSIONS[end]


# Automatically pipes errors to new file
# and appends stdout to build.log
function run_sh(cmd::Cmd, filename::String)

    build_log = joinpath(@__DIR__, "build.log")
    err_log = joinpath(@__DIR__, "$(filename).err")

    if isfile(err_log)
        rm(err_log)
    end

    try
        run(pipeline(cmd, stdout = build_log, stderr = err_log, append = true))
    catch e
        for line in eachline(err_log)
            println(err_log)
            exit(1)
        end
    end

    for line in eachline(build_log)
        println(line)
    end

end

function is_cupynumeric_installed(conda_env_dir::String; throw_errors::Bool = false)

    include_dir = joinpath(conda_env_dir, "include")

    # Far from an exhaustive check, but if these are missing something is definitely wrong
    if !isdir(joinpath(include_dir, "legate"))
        throw_errors && @error "Cannot find include/legate in $(conda_env_dir)"
        return false
    elseif !isdir(joinpath(include_dir, "cupynumeric"))
        throw_errors && @error "Cannot find include/cupynumeric in $(conda_env_dir)"
        return false
    elseif !isdir(joinpath(include_dir, "legion"))
        throw_errors && @error "Cannot find include/legion in $(conda_env_dir)"
        return false
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
    run_sh(`bash $legion_patch $repo_root $conda_env_dir`, "legion_patch")
end

function build_jlcxxwrap(repo_root)

    @info "Downloading libcxxwrap"
    build_libcxxwrap = joinpath(repo_root, "scripts/install_cxxwrap.sh")

    @info "Running libcxxwrap build script: $build_libcxxwrap"
    run_sh(`bash $build_libcxxwrap $repo_root`, "libcxxwrap")
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
    run_sh(`bash $build_cpp_wrapper $repo_root $build_dir $conda_env_dir $nthreads`, "cpp_wrapper")
end

function parse_cupynumeric_version(conda_env_dir)
    version_file = joinpath(conda_env_dir, "include", "cupynumeric", "version_config.hpp")

    version = nothing
    open(version_file, "r") do f
        data = readlines(f)
        major = parse(Int, split(data[end-2])[end])
        minor = lpad(split(data[end-1])[end], 2, '0')
        version = "$(major).$(minor)"
    end

    if isnothing(version)
        error("Failed to parse version from conda environment")
    end

    return version
end

function install_cupynumeric_condajl(env_name, version_to_install)
    @info "Installing cupynumeric into new conda environment"
    Conda.add_channel("conda-forge", env_name)
    Conda.add("cupynumeric=$(version_to_install)", env_name, channel = "legate")
end

function core_build_process(conda_env_dir, run_legion_patch::Bool = true)

    pkg_root = abspath(joinpath(@__DIR__, "../"))
    @info "Parsed Package Dir as: $(pkg_root)"

    run_legion_patch && patch_legion(pkg_root, conda_env_dir)

    # We still need to build libcxxwrap from source until 
    # everything is on BinaryBuilder to ensure compiler compatability
    build_jlcxxwrap(pkg_root)

    # create libcupynumericwrapper.so
    build_cpp_wrapper(pkg_root, conda_env_dir)
end

function build_from_user_conda(conda_env_dir)
    is_cupynumeric_installed(conda_env_dir; throw_errors = true)
    cupynumeric_version = parse_cupynumeric_version(conda_env_dir)
    if cupynumeric_version ∉ SUPPORTED_CUPYNUMERIC_VERSIONS
        error("Your local environment has an unsupported verison of cupynumeric: $(cupynumeric_version)")
    end
    core_build_process(conda_env_dir)
end

function build_from_julia_conda(env_name, version)

    conda_env_dir = Conda.prefix(env_name)

    @info "Using conda environment at : $(conda_env_dir)"

    cupynumeric_installed = is_cupynumeric_installed(conda_env_dir)

    if cupynumeric_installed
        installed_version = parse_cupynumeric_version(conda_env_dir)
        if installed_version ∉ SUPPORTED_CUPYNUMERIC_VERSIONS
            @warn "Detected unsupported version of cupynumeric installed: $(installed_version). Installing newest version."
            install_cupynumeric_condajl(env_name, LATEST_CUPYNUMERIC_VERSION)
        else
            @info "Found cupynumeric already installed."
        end
    else
        install_cupynumeric_condajl(env_name, version)
    end

    core_build_process(conda_env_dir)
end


####################################

const CONDA_JL_MODE = "conda_jl"
const LOCAL_CONDA_MODE = "local_env"
const DEFAULT_ENV_NAME = "cupynumeric"

const mode = load_preference("cuNumeric", "mode", CONDA_JL_MODE)
const conda_jl_env = load_preference("cuNumeric", "conda_jl_env", DEFAULT_ENV_NAME)#CNPreferences.DEFAULT_ENV_NAME)
const user_env = load_preference("cuNumeric", "user_env", nothing)


#* TODO PARSE CUPYNUMERIC VERSION TO DECIDE IF WE NEED TO PATCH LEGION??
#* PARSE GCC/CMAKE VERSION TO MAKE SURE ITS RECENT ENOUGH
#* FIGURE OUT HOW TO AVOID REBUILDING JLCXXWRAPP ?
if mode == CONDA_JL_MODE #CNPreferences.CONDA_JL_MODE
    @info "Building with Conda.jl environment named $(conda_jl_env)."
    build_from_julia_conda(Symbol(conda_jl_env), LATEST_CUPYNUMERIC_VERSION)
elseif mode == LOCAL_CONDA_MODE #CNPreferences.LOCAL_CONDA_MODE
    if isnothing(user_env)
        error("Mode was set to use a local conda environment, but environment path was nothing.")
    end
    @info "Building with local conda environment at $(user_env)"
    build_from_user_conda(user_env)
else
    error("Could not parse build settings. Got mode: $(mode), conda_jl_env: $(conda_jl_env), user_env: $(user_env)")
end
