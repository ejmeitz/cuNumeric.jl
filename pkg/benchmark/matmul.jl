using Pkg
Pkg.activate("../")

using cuNumeric
using LinearAlgebra

const FT = Float32

function initialize_cunumeric(N)
    A = cuNumeric.as_type(cuNumeric.rand(N,N), LegateType(FT))
    B = cuNumeric.as_type(cuNumeric.rand(N,N), LegateType(FT))
    C = cuNumeric.zeros(FT, N, N)
    return A, B, C
end

function total_flops(N)
    return N * N * (2 * N - 1)
end

function total_space(N)
    return 3 * (N^2) * sizeof(FT)
end

# Same as above but use Legate timers
function gemm_cunumeric(N, I, warmup = 5)
  A,B,C = initialize_cunumeric(N)

  start_time = nothing
  # times = []
  for idx in range(1, I + warmup)
    if idx == warmup + 1
        start_time = timer_microseconds()
    end
  
    mul!(C, A, B)
        
  end
  total_time = get_time(timer_microseconds()) - get_time(start_time)
  mean_time = (total_time) / (I * 1000)
  flops = total_flops(N) / (mean_time * 1e6) 

  return mean_time, flops
end

# not very generic but for now whatever
N = parse(Int, ARGS[1])
I = parse(Int, ARGS[2])
W = parse(Int, ARGS[3])

@info "Running MATMUL benchmark with $(calc) on $(N)x$N matricies for $I iterations, $W warmups"

μ, flops = gemm_cunumeric(N,I,W)
println("cuNumeric Mean Run Time: $(μ) μs")
println("cuNumeric FLOPS: $(flops) GFLOPS")

# ./run_benchmark.sh matmul.jl --cpus 10 --gpus 1 1000 25 5
