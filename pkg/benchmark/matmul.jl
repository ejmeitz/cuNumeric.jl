using cuNumeric
using BenchmarkTools
using LinearAlgebra
#using CUDA

const FT = Float32


function initialize_cunumeric(N)
    A = cuNumeric.as_type(cuNumeric.rand(N,N), LegateType(FT))
    B = cuNumeric.as_type(cuNumeric.rand(N,N), LegateType(FT))
    C = cuNumeric.zeros(FT, N, N)
    return A, B, C
end

function initialize_julia(N)
  A = rand(FT, N, N)
  B = rand(FT, N, N)
  C = zeros(FT, N, N)
  return A, B, C
end
#=
function initialize_cuda_jl(N)
  A = CUDA.rand(FT, N, N)
  B = CUDA.rand(FT, N, N)
  C = CUDA.zeros(FT, N, N)
  return A, B, C
end
=#
function total_flops(N)
    return N * N * (2 * N - 1)
end

function total_space(N)
    return 3 * (N^2) * sizeof(FT)
end

function gemm_julia(N, I, init_fn::Function)
  BLAS.set_num_threads(Threads.nthreads()) 
  A,B,C = init_fn(N)
  t = @benchmark mul!($C, $A, $B) evals = 1 samples = I seconds = 30
  actual_samples = length(t.times)
  mean_time = mean(t).time # this is returned as nanoseconds
  flops = total_flops(N) / (mean_time * 1e6)
  return mean_time/1e3, std(t).time/1e3, actual_samples, flops
end

# Same as above but use Legate timers
function gemm_cunumeric(N, I, warmup = 5)
  A,B,C = initialize_cunumeric(N)

  start_time = nothing
  # times = []
  for idx in range(1, I + warmup)
    if idx == warmup + 1
        start_time = get_time_microseconds()
    end
    mul!(C, A, B)
    

    # We need to rotate the matrices to keep Legate honest
    # about moving data so it can't just duplicate A and B
    # on the first iteration and reuse them, this means
    # that A, B, C all need to be square

    # A, B, C = B, C, A
  end
  end_time = get_time_microseconds()

  mean_time = (end_time-start_time) / (I * 1000)
  flops = total_flops(N) / (mean_time * 1e6) 

  return mean_time, flops
end

# not very generic but for now whatever
calc = lowercase(ARGS[1]) #cunumeric, julia, cudajl
N = parse(Int, ARGS[2])
I = parse(Int, ARGS[3])

@info "Running MATMUL benchmark with $(calc) on $(N)x$N matricies for $I iterations"

if calc == "cunumeric"
  μ, flops = gemm_cunumeric(N,I)
  println("cuNumeric Mean Run Time: $(μ) μs")
  println("cuNumeric FLOPS: $(flops) GFLOPS")
elseif calc == "julia"
  μ, σ, N_actual, flops = gemm_julia(N, I, initialize_julia)
  println("Julia CPU Mean Run Time: $(μ) +/- $(σ) μs")
  println("Julia CPU FLOPS: $(flops) GFLOPS")
elseif calc == "cudajl"
  μ, σ, N_actual, flops = gemm_julia(N, I, initialize_cuda_jl)
  println("CUDA.jl Mean Run Time: $(μ) +/- $(σ) μs")
  println("CUDA.jl FLOPS: $(flops) GFLOPS")
end


# ./run_benchmark.sh matmul.jl --cpus 10 --gpus 1 cuNumeric 1000 25
