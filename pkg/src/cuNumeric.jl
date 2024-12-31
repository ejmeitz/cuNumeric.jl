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

# DEBUG HELP: use tool `c++filt -t [St8optionalIN11cupynumeric7NDArrayEE]`
# this tool helps with reading these c++ strings from libcupynumericwrapper.so
# the above yields:: std::optional<cupynumeric::NDArray>

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

    # BREAK THE LEGATE/CUNUMERIC OPTIONS OUT INTO CLASS
    # SO THEY CAN BE STARTED AND STOPPED MULTIPLE TIMES
    # INSIDE OF A SINGLE JULIA CODE WITH DIFFERENT ARGS
    global ARGV = ArgcArgv([Base.julia_cmd()[1], ARGS...])
    
    res = cuNumeric.start_legate(ARGV.argc, getargv(ARGV))
    if res == 0
        @info "Started Legate successfully"
    else
        @error "Failed to start Legate, got exit code $(res), exiting"
        Base.exit(res)
    end
    Base.atexit(cuNumeric.legate_finish)

    # void return
    cuNumeric.initialize_cunumeric(ARGV.argc, getargv(ARGV))
end


end
