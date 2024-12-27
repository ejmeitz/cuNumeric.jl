
function Base.:*(array1::cuNumeric.NDArray, array2::cuNumeric.NDArray)
    return array1.multiply(array2)
end

function Base.:+(array1::cuNumeric.NDArray, array2::cuNumeric.NDArray)
    return array1.add(array2)
end