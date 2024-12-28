using cuNumeric

N = 10000

ad = ArrayDesc((N, N), Float32)
arr = cuNumeric.zeros(ad.dims, ad.type)

arr2 = cuNumeric.full(ad.dims, cuNumeric.Scalar(6.0, cuNumeric.float32))

print(arr2)