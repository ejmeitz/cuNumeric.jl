using cuNumeric

using CUDA
import CUDA: i32

function kernel_add(a, b, c, N)
    i = (blockIdx().x - 1i32) * blockDim().x + threadIdx().x
    if i <= N
        @inbounds c[i] = a[i] + b[i]
    end
    return nothing
end


N = 1024
threads = 256
blocks = cld(N, threads)
dummy = cuNumeric.zeros(Float32, 1)

a = cuNumeric.full(N, 1.0f0)
b = cuNumeric.full(N, 2.0f0)
c = cuNumeric.zeros(Float32, N)

task = cuNumeric.@cuda_task kernel_add(a, b, c, Int32(1))


# ac = CUDA.fill(1.0f0, N)
# bc = CUDA.fill(2.0f0, N)
# cc = CUDA.zeros(Float32, N)

# cuNumeric.@launch task=task threads=threads blocks=blocks kernel_add(cudaconvert(ac), cudaconvert(bc), cudaconvert(cc), N)

# println("Result: ", Array(cc))
