

function sgemm()

    N = 100
    FT = Float32

    dims = (N,N)

    # Base julia arrays
    A_cpu = rand(FT, dims);
    B_cpu = rand(FT, dims);

    # cunumeric arrays
    A = cuNumeric.zeros(dims)
    B = cuNumeric.zeros(dims)

    # Initialize NDArrays with random values
    # used in Julia arrays
    for i in 1:N
        for j in 1:N
            A[i, j] = Float64(A_cpu[i, j])
            B[i, j] = Float64(B_cpu[i, j])
        end
    end

    # Needed to start as Float64 to 
    # initialize the NDArray
    C_cpu = A_cpu * B_cpu

    A = cuNumeric.as_type(A, LegateType(FT))
    B = cuNumeric.as_type(B, LegateType(FT))
    C = cuNumeric.zeros(FT, N, N)

    mul!(C, A, B)

    @warn "SGEMM Probably failed cause of precision 🥲"
    @test C == C_cpu

    C = A * B

end