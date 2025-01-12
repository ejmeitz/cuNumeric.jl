using cuNuermic
using BenchmarkTools
using LinearAlgebra
using CUDA



function initialize_cunumeric(N, ft::Type{<:AbstractFloat})
    A = as_type(random(N, N), ft) #* TODO ACTUALLY REIMPLEMENT Base.rand
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

function initialize_cuda_jl(N, ft)
  A = CUDA.rand(Float32, N, N)
  B = CUDA.rand(Float32, N, N)
  C = CUDA.zeros(Float32, N, N)
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
  return median(t), std(t), actual_samples
end

# Same as above but use Legate timers
function gemm_cunumeric(N, ft::Type{<:AbstractFloat})
  start_time = 0.0
  for idx in range(I + warmup)
    if idx == warmup
        start_time = time_microseconds()
    end
    np.dot(A, B, out=C)

    # We need to rotate the matrices to keep Legate honest
    # about moving data so it can't just duplicate A and B
    # on the first iteration and reuse them, this means
    # that A, B, C all need to be square
    A, B, C = B, C, A
  end
  end_time = time_microseconds()
end


function run_gemm(N, I, warmup, ft::Type{<:AbstractFloat}) 
    print("Problem Size:     M=" * string(N) * " N=" * string(N) * " K=" * string(N))
    print("Total Iterations: " * string(I))
    flops = total_flops(N)
    print("Total Flops:      " * string(flops / 1e9) * " GFLOPS/iter")
    space = total_space(N, ft)
    print("Total Size:       " * string(space / 1e6) * " MB")
    A, B, C = initialize(N, ft)

    timer.start()
    # Run for as many iterations as was requested
    for idx in range(I + warmup)
      if idx == warmup
          timer.start()
      end
      np.dot(A, B, out=C)

      # We need to rotate the matrices to keep Legate honest
      # about moving data so it can't just duplicate A and B
      # on the first iteration and reuse them, this means
      # that A, B, C all need to be square
      A, B, C = B, C, A
    end
    total = timer.stop()

    print("Elapsed Time:     " + str(total) + " ms")
    average = total / I
    print("Average GEMM:     " + str(average) + " ms")
    print("FLOPS/s:          " + str(flops / (average * 1e6)) + " GFLOPS/s")
    return total

end