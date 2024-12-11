module cuNumeric

using CxxWrap
path_to_wrapper_lib = "libcupynumericwrapper.so"
@wrapmodule(() -> joinpath(@__DIR__, "..", "..", "build", path_to_wrapper_lib))

# Runtime initilization
# Called once in lifetime of code
function __init__()
    @initcxx

    
    # initialize cupynumeric and legate like
    # done in stencil.cc

    #legate::start
    #cupynumeric::initialize


    # where to do legate::final??
end

end