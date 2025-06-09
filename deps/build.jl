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

using Preferences

using Legate
using HDF5_jll
using NCCL_jll
using CUTENSOR_jll


const SUPPORTED_CUPYNUMERIC_VERSIONS = ["25.05.00"]
const LATEST_CUPYNUMERIC_VERSION = SUPPORTED_CUPYNUMERIC_VERSIONS[end]


# Automatically pipes errors to new file
# and appends stdout to build.log
function run_sh(cmd::Cmd, filename::String)

    println(cmd)
    
    build_log = joinpath(@__DIR__, "build.log")
    err_log = joinpath(@__DIR__, "$(filename).err")

    if isfile(err_log)
        rm(err_log)
    end

    try
        run(pipeline(cmd, stdout = build_log, stderr = err_log, append = false))
    catch e
        println("stderr log generated: ", err_log, '\n')
        exit(-1)
    end
end

function is_cupynumeric_installed(cupynumeric_dir::String; throw_errors::Bool = false)

    include_dir = joinpath(cupynumeric_dir, "include")

    if !isdir(joinpath(include_dir, "cupynumeric"))
        throw_errors && @error "Cannot find include/cupynumeric in $(cupynumeric_dir)"
        return false
    end 

    return true
end

# patch legion. The readme below talks about our compilation error
# https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md
function patch_legion(repo_root::String, legate_loc::String)
    @info "Patching Legion"
    
    legion_patch = joinpath(repo_root, "scripts/patch_legion.sh")
    @info "Running legion patch script: $legion_patch"
    run_sh(`bash $legion_patch $repo_root $legate_loc`, "legion_patch")
end

function build_cpp_wrapper(repo_root, cupynumeric_loc, legate_loc, hdf5_loc)

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
    run_sh(`bash $build_cpp_wrapper $cupynumeric_loc $legate_loc $hdf5_loc $repo_root $build_dir $nthreads`, "cpp_wrapper")
end

function parse_cupynumeric_version(cupynumeric_dir)
    version_file = joinpath(cupynumeric_dir, "include", "cupynumeric", "version_config.hpp")

    version = nothing
    open(version_file, "r") do f
        data = readlines(f)
        major = parse(Int, split(data[end-2])[end])
        minor = lpad(split(data[end-1])[end], 2, '0')
        patch = lpad(split(data[end])[end], 2, '0')
        version = "$(major).$(minor).$(patch)"
    end

    if isnothing(version)
        error("Failed to parse version from conda environment")
    end

    return version
end


function install_cupynumeric(repo_root, version_to_install)
    @info "Building cupynumeric"

    build_dir = joinpath(repo_root, "libcupynumeric")
    if !isdir(build_dir)
        mkdir(build_dir)
    else
        @warn "Build dir exists. Deleting prior build."
        rm(build_dir, recursive = true)
        mkdir(build_dir)
    end

    legate_loc = Legate.get_jll()
    nccl_loc = NCCL_jll.artifact_dir
    cutensor_loc = CUTENSOR_jll.artifact_dir
    build_cupynumeric = joinpath(repo_root, "scripts/build_cupynumeric.sh")
    nthreads = Threads.nthreads()
    run_sh(`bash $build_cupynumeric $repo_root $legate_loc $nccl_loc $cutensor_loc $build_dir $version_to_install $nthreads`, "cupynumeric")
end

function check_prefix_install(env_var, env_loc)
    if get(ENV, env_var, "0") == "1"
        @info "Using $(env_var) mode"
        cupynumeric_dir = get(ENV, env_loc, nothing)
        cupynumeric_installed = is_cupynumeric_installed(cupynumeric_dir)
        if !cupynumeric_installed
            error("Build halted: cupynumeric not found in $cupynumeric_dir")
        end
        installed_version = parse_cupynumeric_version(cupynumeric_dir)
        if installed_version ∉ SUPPORTED_CUPYNUMERIC_VERSIONS
            error("Build halted: $(cupynumeric_dir) detected unsupported version $(installed_version)")
        end
        @info "Found a valid install in: $(cupynumeric_dir)"
        return true
    end
    return false
end

function build()
    pkg_root = abspath(joinpath(@__DIR__, "../"))
    @info "Parsed Package Dir as: $(pkg_root)"
    # custom install 
    if check_prefix_install("CUNUMERIC_CUSTOM_INSTALL", "CUNUMERIC_CUSTOM_INSTALL_LOCATION")
        cupynumeric_dir = get(ENV, "CUNUMERIC_CUSTOM_INSTALL_LOCATION", nothing)
    # conda install 
    elseif check_prefix_install("CUNUMERIC_LEGATE_CONDA_INSTALL", "CONDA_PREFIX")
        cupynumeric_dir = get(ENV, "CONDA_PREFIX", nothing)
    else # default install 
        cupynumeric_dir = abspath(joinpath(@__DIR__, "../libcupynumeric"))
        cupynumeric_installed = is_cupynumeric_installed(cupynumeric_dir)
        if cupynumeric_installed
            installed_version = parse_cupynumeric_version(cupynumeric_dir)
            if installed_version ∉ SUPPORTED_CUPYNUMERIC_VERSIONS
                @warn "Detected unsupported version of cupynumeric installed: $(installed_version). Installing newest version."
                install_cupynumeric(pkg_root, LATEST_CUPYNUMERIC_VERSION)
            else
                @info "Found cupynumeric already installed."
            end
        else
            install_cupynumeric(pkg_root, LATEST_CUPYNUMERIC_VERSION)
        end
    end

    # create libcupynumericwrapper.so
    legate_loc = Legate.get_jll()
    hdf5_loc = HDF5_jll.artifact_dir
    build_cpp_wrapper(pkg_root, cupynumeric_dir, legate_loc, hdf5_loc)
end

build()