using cuNumeric

N = 1000
dims = (N, N)


α_cpu = 56.6
x_cpu = zeros(dims);
y_cpu = zeros(dims);

# cunumeric arrays

# TODO 
# result = α * x + y  
# ERROR: MethodError: no method matching *(::Float64, ::cuNumeric.NDArrayAllocated)     
α = cuNumeric.full(dims, Float64(56.6))
x = cuNumeric.zeros(dims)
y = cuNumeric.zeros(dims)


for i in N
    for j in N
        x_cpu[i, j] = rand()
        y_cpu[i, j] = rand()
        # set cunumeric.jl arrays
        x[i, j] = x_cpu[i, j]
        y[i, j] = y_cpu[i, j]
    end
end


result = α * x + y

# check results 
for i in N
    for j in N
        test = result[(i, j)]
        if (test != (α_cpu * x_cpu[i, j] + y_cpu[i, j]))
            error("values don't match at ($i, $j)")
        end
    end
end