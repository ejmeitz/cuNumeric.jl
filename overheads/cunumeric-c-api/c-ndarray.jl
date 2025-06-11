using cuNumeric
using BenchmarkTools

@noinline function loop_array_no_time(iters::Integer, size::Integer = 500_000)
    for _ in range(1,iters)
        arr = cuNumeric.nda_full_array(UInt64[size], 3.1415)
        GC.gc(false)
    end
end

@btime loop_array_no_time(1000)
