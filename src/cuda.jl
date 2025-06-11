using CUDA

function kernel_add(a, b, c)
    i = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    if i <= length(a)
        @inbounds c[i] = a[i] + b[i]
    end
    return
end

# Dummy launch to force compilation
a = CUDA.fill(1.0f0, 10)
b = CUDA.fill(2.0f0, 10)
c = CUDA.fill(0.0f0, 10)
@cuda threads=10 kernel_add(a, b, c)

# Use code_ptx correctly
buf = IOBuffer()
CUDA.code_ptx(buf, kernel_add, (typeof(a), typeof(b), typeof(c)))
ptx = String(take!(buf))

# Debug output
println("PTX preview:")
println(first(split(ptx, '\n'), 10))  # first 10 lines

# Save to file
ptx_path = "kernel_add.ptx"
open(ptx_path, "w") do f
    write(f, ptx)
end

# Make sure the file has `.entry kernel_add`
# Then:
mod = CuModule(ptx_path)
fun = CuFunction(mod, "kernel_add")
CUDA.@sync launch(fun, (1,), (10,), a, b, c)
