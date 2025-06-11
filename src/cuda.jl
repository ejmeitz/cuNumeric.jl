using CUDA

# Your kernel
function kernel_add(a, b, c)
    i = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if i <= length(a)
        c[i] = a[i] + b[i]
    end
end

# Compile kernel with @cuda (for PTX)
a = CuArray{Float32}(undef, 1)
b = CuArray{Float32}(undef, 1)
c = CuArray{Float32}(undef, 1)

argtypes = (typeof(a), typeof(b), typeof(c))

# ptx = CUDA.code_ptx(kernel_add, argtypes)

buf = IOBuffer()
CUDA.code_ptx(buf, kernel_add, argtypes)
ptx = String(take!(buf))

if ptx === nothing
    error("PTX generation failed")
end

# Load PTX module
mod = CuModule(ptx)

# Get function by name (name mangling can happen, inspect `ptx` or use known kernel name)
fn_name = "julia_kernel_add"  # You might need to find the exact symbol name from PTX

fun = CuFunction(mod, fn_name)

# Launch kernel manually
threads = 256
blocks = 1

CUDA.@sync launch(fun, (blocks,), (threads,), a, b, c)
