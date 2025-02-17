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
using Pkg
# import CNPreferences

using LinearAlgebra
import LinearAlgebra: mul!

using Random
import Random: rand, rand!

import Base: abs, angle, acos, acosh, asin, asinh, atan, atanh, cbrt,
             ceil, clamp, conj, cos, cosh, cosh, deg2rad, exp, exp2, expm1,
             floor, frexp, imag, isfinite, isinf, isnan, log, log10, 
             log1p, log2, !, modf, -, rad2deg, sign, signbit, sin,
             sinh, sqrt, tan, tanh, trunc, +, *, atan, &, |, ⊻, copysign,
             /, ==, ^, div, gcd, > , >=, hypot, isapprox, lcm, ldexp, <<,
             < , <=, !=, >>, all, any, argmax, argmin, maximum, minimum,
             prod, sum

# abstract type AbstractFieldAccessor{PM,FT,n_dims} end
# abstract type AbstractAccessorRO{T,N} end #probably should be subtype of AbstractFieldAccessor
# abstract type AbstractAccessorWO{T,N} end

lib = "libcupynumericwrapper.so"
@wrapmodule(() -> joinpath(@__DIR__, "../", "wrapper", "build", lib))

include("util.jl")
include("ndarray.jl")
include("unary.jl")
include("binary.jl")

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


function my_on_exit()
    @info "Cleaning Up Legate"
    cuNumeric.legate_finish()
end

function cupynumeric_setup(AA::ArgcArgv)
   
    # Capture stdout from start_legate to 
    # see the hardware configuration
    res = 0
    pipe = Pipe()
    started = Base.Event()
    writer = @async redirect_stdout(pipe) do
        notify(started)
        cuNumeric.start_legate()
        close(Base.pipe_writer(pipe))
    end

    wait(started)
    legate_config_str = Base.read(pipe, String)
    wait(writer) 
    print(legate_config_str)

    if res == 0
        @info "Started Legate successfully"
    else
        @error "Failed to start Legate, got exit code $(res), exiting"
        Base.exit(res)
    end
    Base.atexit(my_on_exit)

    cuNumeric.initialize_cunumeric(AA.argc, getargv(AA))

    return legate_config_str
end


global legate_config::String = ""

function versioninfo()
    msg = """
        Legate Configuration: $(legate_config)
    """
    println(msg)
end

# Runtime initilization
# Called once in lifetime of code
function __init__()
    CNPreferences.check_unchanged()
    @initcxx

    # Legate ignores these arguments...
    AA = ArgcArgv([Base.julia_cmd()[1]])

    @info "Starting Legate"
    global legate_config_str = cupynumeric_setup(AA) #* TODO Parse this and add a versioninfo
    
end
end
