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
using legate_jll
using HDF5_jll

# import CNPreferences

const SUPPORTED_CUPYNUMERIC_VERSIONS = ["25.03.00"]
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

    # for line in eachline(build_log)
    #     println(line)
    # end

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
    @warn "This will modify your cupynumeric install"
    
    legion_patch = joinpath(repo_root, "scripts/patch_legion.sh")
    @info "Running legion patch script: $legion_patch"
    run_sh(`bash $legion_patch $repo_root $legate_loc`, "legion_patch")
end

function build_jlcxxwrap(repo_root)

    @info "Downloading libcxxwrap"
    build_libcxxwrap = joinpath(repo_root, "scripts/install_cxxwrap.sh")

    @info "Running libcxxwrap build script: $build_libcxxwrap"
    run_sh(`bash $build_libcxxwrap $repo_root`, "libcxxwrap")
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


function core_build_process(pkg_root, cupynumeric_loc, run_legion_patch::Bool = true)
    legate_loc = legate_jll.artifact_dir
    hdf5_loc = HDF5_jll.artifact_dir

    run_legion_patch && patch_legion(pkg_root, legate_loc)

    # We still need to build libcxxwrap from source until 
    # everything is on BinaryBuilder to ensure compiler compatability
    # build_jlcxxwrap(pkg_root)

    # create libcupynumericwrapper.so
    build_cpp_wrapper(repo_root, cupynumeric_loc, legate_loc, hdf5_loc)
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
    
    legate_loc = legate_jll.artifact_dir
    build_cupynumeric = joinpath(repo_root, "scripts/build_cupynumeric.sh")
    nthreads = Threads.nthreads()
    run_sh(`bash $build_cupynumeric $repo_root $legate_loc $build_dir $version_to_install $nthreads`, "cupynumeric")
end

function build()
    pkg_root = abspath(joinpath(@__DIR__, "../"))
    @info "Parsed Package Dir as: $(pkg_root)"

    cupynumeric_dir = joinpath(pkg_root, "/libcupynumeric")

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

    core_build_process(pkg_root, cupynumeric_loc)
end



build()