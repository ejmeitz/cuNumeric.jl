using cuNumeric

N = 1000
dims = (N, N)
arr = cuNumeric.zeros(dims, Float64)
arr2 = cuNumeric.full(dims, Float64(5.0))



# arr = arr + arr2 