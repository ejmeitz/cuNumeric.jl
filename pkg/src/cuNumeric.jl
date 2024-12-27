module cuNumeric
using CxxWrap
lib = "libcupynumericwrapper.so"
@wrapmodule(() -> joinpath(@__DIR__, "../", "../", "build", lib))

# From https://github.com/JuliaGraphics/QML.jl/blob/dca239404135d85fe5d4afe34ed3dc5f61736c63/src/QML.jl#L147
mutable struct ArgcArgv
    argv
    argc::Ref{Cint}
  
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

    global ARGV = ArgcArgv([Base.julia_cmd()[1], ARGS...])

    cuNumeric.start_legate(ARGV.argc, getargv(ARGV))
    cuNumeric.initialize_cunumeric(ARGV.argc, getargv(ARGV))

    Base.atexit(cuNumeric.legate_finish)
end


end
