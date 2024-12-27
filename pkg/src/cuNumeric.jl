module cuNumeric
using CxxWrap
lib = "libcupynumericwrapper.so"
@wrapmodule(() -> joinpath(@__DIR__, "../", "../", "build", lib))


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
@static global ARGV::ArgcArgv  

# Runtime initilization
# Called once in lifetime of code
function __init__()
    @initcxx

    global ARGV = ArgcArgv([Base.julia_cmd()[1], ARGS...])
    # initialize cupynumeric and legate like
    cuNumeric.start_legate(ARGV.argc, getargv(ARGV))
    cuNumeric.initialize_cunumeric(ARGV.argc, getargv(ARGV))

    Base.atexit(cuNumeric.legate_finish)
end



import Base: *, +

function *(array1::cuNumeric.NDArray, array2::cuNumeric.NDArray)
    return array1.multiply(array2)
end

function +(array1::cuNumeric.NDArray, array2::cuNumeric.NDArray)
    return array1.add(array2)
end

end
