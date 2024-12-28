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
module cuNumeric

using CxxWrap

lib = "libcupynumericwrapper.so"
@wrapmodule(() -> joinpath(@__DIR__, "../", "../", "build", lib))

include("ndarray.jl")

# From https://github.com/JuliaGraphics/QML.jl/blob/dca239404135d85fe5d4afe34ed3dc5f61736c63/src/QML.jl#L147
mutable struct ArgcArgv
    argv
    argc::Cint
  
    function ArgcArgv(args::Vector{String})
      argv = Base.cconvert(CxxPtr{CxxPtr{CxxChar}}, args)
      argc = length(args)
      return new(argv, argc)
    end
  end
  
getargv(a::ArgcArgv) = Base.unsafe_convert(CxxPtr{CxxPtr{CxxChar}}, a.argv)
global ARGV::ArgcArgv  

# Runtime initilization
# Called once in lifetime of code
function __init__()
    @initcxx

    @info "Starting legate and cunumeric"

    global ARGV = ArgcArgv([Base.julia_cmd()[1], ARGS...])
    
    # res1 = cuNumeric.start_legate(ARGV.argc, getargv(ARGV))
    res1 = cuNumeric.start_legate(0, [""])
    if res1 == 0
        @info "Started Legate successfully"
    else
        @error "Failed to start Legate, exiting"
        # Base.exit(-1)
    end
    Base.atexit(cuNumeric.legate_finish)

    # res2 = cuNumeric.initialize_cunumeric(ARGV.argc, getargv(ARGV))
    res2 = cuNumeric.initialize_cunumeric(0, [""])
    if res2 == 0
        @info "Initialized cunumeric successfully"
    else
        @error "Failed to initialize cunumeric, exiting"
        # Base.exit(-1)
    end


end


end
