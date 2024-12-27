module cuNumeric
using CxxWrap
lib = "libcupynumericwrapper.so"
@wrapmodule(() -> joinpath(@__DIR__, "../", "../", "build", lib))

    # Runtime initilization
    # Called once in lifetime of code
function __init__()
    @initcxx

    # initialize cupynumeric and legate like
    cuNumeric.start_legate(0, [""])
    cuNumeric.initialize_cunumeric(0, [""])
end


function __del__()
    cuNumeric.legate_finish()
end


import Base: *

function *(array1::cuNumeric.NDArray, array2::cuNumeric.NDArray)
    return array1.multiply(array2)
end

import Base: +

function +(array1::cuNumeric.NDArray, array2::cuNumeric.NDArray)
    return array1.add(array2)
end

end
