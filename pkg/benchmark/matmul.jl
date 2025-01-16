using cuNuermic
using BenchmarkTools
using LinearAlgebra
using CUDA


#* TODO ACTUALLY REIMPLEMENT Base.rand
#* so the interfaces match
function initialize_cunumeric(N, ft::Type{<:AbstractFloat})
    A = as_type(random(N, N), ft) #* TODO IMPLEMENT as_type
    B = as_type(random(N, N), ft)
    C = zeros(ft, N, N)
    return A, B, C
end

function initialize_julia(N, ft::Type{<:AbstractFloat})
  A = rand(ft, N, N)
  B = rand(ft, N, N)
  C = zeros(ft, N, N)
  return A, B, C
end

function initialize_cuda_jl(N, ft::Type{<:AbstractFloat})
  A = CUDA.rand(ft, N, N)
  B = CUDA.rand(ft, N, N)
  C = CUDA.zeros(ft, N, N)
  return A, B, C
end

function total_flops(N)
    return N * N * (2 * N - 1)
end

function total_space(N, ft::Type{<:AbstractFloat})
    return 3 * (N^2) * sizeof(ft)
end

function gemm_julia(N, I, ft::Type{<:AbstractFloat}, init_fn::Function)
  BLAS.set_num_threads(Threads.nthreads()) 
  A,B,C = init_fn(N, ft)
  t = @benchmark mul!($C, $A, $B) evals = 1 samples = I seconds = 30
  actual_samples = length(t.times)
  mean_time = mean(t)
  flops = total_flops(N) / (mean_time * 1e6)
  return mean(t), std(t), actual_samples, flops
end

# Same as above but use Legate timers
function gemm_cunumeric(N, I, warmup, ft::Type{<:AbstractFloat})
  A,B,C = initialize_cunumeric(N, ft)

  start_time = nothing
  for idx in range(I + warmup)
    if idx == warmup
        start_time = time_microseconds()
    end
    mul!(C, A, B) #* NOT IMPLEMENTED YET

    # We need to rotate the matrices to keep Legate honest
    # about moving data so it can't just duplicate A and B
    # on the first iteration and reuse them, this means
    # that A, B, C all need to be square

    # Not sure if just swapping the 
    # pointers to NDArray has that ^^^ effect???
    A, B, C = B, C, A
  end
  end_time = time_microseconds()

  mean_time = (end_time-start_time) / I
  flops = total_flops(N) / (mean_time * 1e6)
end


