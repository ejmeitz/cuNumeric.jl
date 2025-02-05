var documenterSearchIndex = {"docs":
[{"location":"api/#Public-API","page":"Public API","title":"Public API","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"User facing functions supported by cuNumeric.jl","category":"page"},{"location":"api/","page":"Public API","title":"Public API","text":"Pages = [\"api.md\"]\nDepth = 2:2","category":"page"},{"location":"api/#Initializing-NDArrays","page":"Public API","title":"Initializing NDArrays","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"The CuPyNumeric C++ API only supports generating Float64 random numbers. The example below shows how you can get Float32 random numbers by casting. We plan to make this easier through Base.convert or by getting Float32 generating added to CuPyNumeric.","category":"page"},{"location":"api/","page":"Public API","title":"Public API","text":"arr_fp64 = rand(NDArray, 100)\narr_fp32 = cuNumeric.as_type(arr_fp64, LegateType(Float32))","category":"page"},{"location":"api/#Methods-to-intiailize-NDArrays","page":"Public API","title":"Methods to intiailize NDArrays","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"cuNumeric.zeros\ncuNumeric.full\nRandom.rand!\nRandom.rand","category":"page"},{"location":"api/#Slicing-NDArrays","page":"Public API","title":"Slicing NDArrays","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"TODO","category":"page"},{"location":"api/#Linear-Algebra-Operations","page":"Public API","title":"Linear Algebra Operations","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"Matrix multiplicaiton is only implemented through mul!. Calling the * operator on a pair of 2D NDArrays will perform elementwise multiplication.","category":"page"},{"location":"api/#Implemented-Linear-Algebra-Operations","page":"Public API","title":"Implemented Linear Algebra Operations","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"LinearAlgebra.mul!","category":"page"},{"location":"api/#Unary-Operations","page":"Public API","title":"Unary Operations","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"All unary operations will return a new NDArray and are broadcast over an NDarray even without the . broadcasting syntax. In the current state, . broadcasting syntax will not work (e.g. sin.(arr)).","category":"page"},{"location":"api/","page":"Public API","title":"Public API","text":"Unary operators can also be called with map. For example","category":"page"},{"location":"api/","page":"Public API","title":"Public API","text":"arr = cuNumeric.rand(NDArray, 100)\n\nres1 = sqrt(arr)\nres2 = map(sqrt, arr)","category":"page"},{"location":"api/#Implemented-Unary-Operations","page":"Public API","title":"Implemented Unary Operations","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"Base.abs\nBase.acos\nBase.asin\nBase.asinh\nBase.atanh\nBase.cbrt\nBase.conj\nBase.cos\nBase.cosh\nBase.deg2rad\nBase.exp\nBase.expm1\nBase.floor\nBase.log\nBase.log10\nBase.log1p\nBase.log2\nBase.:(-)\nBase.rad2deg\nBase.sin\nBase.sinh\nBase.sqrt\nBase.tan\nBase.tanh","category":"page"},{"location":"api/#Unary-Reductions","page":"Public API","title":"Unary Reductions","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"Unary reductions convert an NDArray to a single number. Unary reductions cannot be called with Base.reduce at this time.","category":"page"},{"location":"api/#Implemented-Unary-Reductions","page":"Public API","title":"Implemented Unary Reductions","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"Base.all\nBase.any\nBase.maximum\nBase.minimum\nBase.prod\nBase.sum","category":"page"},{"location":"api/#Binary-Operations","page":"Public API","title":"Binary Operations","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"All binary operations will return a new NDArray and are broadcast over an NDarray even without the . broadcasting syntax. In the current state, . broadcasting syntax will not work (e.g. sin.(arr)).","category":"page"},{"location":"api/","page":"Public API","title":"Public API","text":"Binary operators can also be called with map. For example","category":"page"},{"location":"api/","page":"Public API","title":"Public API","text":"arr1 = cuNumeric.rand(NDArray, 100)\narr2 = cuNumeric.rand(NDArray, 100)\n\nres1 = arr1*arr2\nres2 = map(*, arr1, arr2)","category":"page"},{"location":"api/#Implemented-Binary-Operations","page":"Public API","title":"Implemented Binary Operations","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"Base.:(+)\nBase.atan\nBase.:(/)\nBase.:(^)\nBase.div\nBase.hypot\nBase.:(*)\nBase.(-)","category":"page"},{"location":"api/#Timing-cuNumeric.jl-Code","page":"Public API","title":"Timing cuNumeric.jl Code","text":"","category":"section"},{"location":"api/","page":"Public API","title":"Public API","text":"These timers will block until all prior Legate operations are complete.","category":"page"},{"location":"api/","page":"Public API","title":"Public API","text":"get_time_microseconds\nget_time_nanoseconds","category":"page"},{"location":"usage/#About-NDArrays","page":"Back End Details","title":"About NDArrays","text":"","category":"section"},{"location":"usage/#Setting-Hardware-Configuration","page":"Back End Details","title":"Setting Hardware Configuration","text":"","category":"section"},{"location":"usage/","page":"Back End Details","title":"Back End Details","text":"There is no programatic way to set the hardware configuration used by CuPyNumeric (as of 24.11). By default, the hardware configuration is set automatically by Legate. This configuration can be manipulated through the following environment variables:","category":"page"},{"location":"usage/","page":"Back End Details","title":"Back End Details","text":"LEGATE_SHOW_CONFIG : When set to 1, the Legate config is printed to stdout\nLEGATE_AUTO_CONFIG: When set to 1, Legate will automatically choose the hardware configuration\nLEGATE_CONFIG: A string representing the hardware configuration to set","category":"page"},{"location":"usage/","page":"Back End Details","title":"Back End Details","text":"These variables must be set before launching the Julia instance running cuNumeric.jl. We recommend setting export LEGATE_SHOW_CONFIG=1 so that the hardware configuration will be printed when Legate starts. This output is automatically captured and relayed to the user.","category":"page"},{"location":"usage/","page":"Back End Details","title":"Back End Details","text":"To manually set the hardware configuration, export LEGATE_AUTO_CONFIG=0, and then define your own config with something like export LEGATE_CONFIG=\"--gpus 1 --cpus 10 --ompthreads 10\". We recommend using the default memory configuration for your machine and only settings the gpus, cpus and ompthreads. More details about the Legate configuration can be found in the NVIDIA Legate documentation. If you know where Legate is installed on your computer you can also run legate --help for more detailed information.","category":"page"},{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/#DAXPY","page":"Examples","title":"DAXPY","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"include(\"../../../../examples/daxpy.jl\")","category":"page"},{"location":"examples/#Monte-Carlo-Integration","page":"Examples","title":"Monte-Carlo Integration","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Most integrals can be estimated with a basic Monte-Carlo estimator:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"hatI_N = fracOmegaNsum_i=1^Nf(x_i)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"where N is the number of samples, Omega is the volume of the domain and x_i are sampled indpendently and uniformly at random from the domain. This estimator is guranteed to converge (subject to some minor constraints) at a rate independent of the dimension and is embaressingly parallel to compute!","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"In the example below, we estimate the integral:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"I = int_-infty^inftye^-x^2","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Since we cannot uniformly sample form negative to positive infinity, we truncate the domain between -5 and 5. This is ok since the integrand exponentially decays and we won't be off by much in the end.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"include(\"../../../../examples/integration.jl\")","category":"page"},{"location":"examples/#Gray-Scott-Reaction-Diffusion","page":"Examples","title":"Gray Scott Reaction Diffusion","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"include(\"../../../../examples/gray-scott.jl\")","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: Simulation Output)","category":"page"},{"location":"benchmark/#Benchmarking-cuNumeric.jl-Programs","page":"Benchmarking","title":"Benchmarking cuNumeric.jl Programs","text":"","category":"section"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"Since there is no programatic way to set the hardware configuration (as of 24.11) benchmarking cuNumeric.jl code is a bit tedious. As an introduction, we walk through a benchmark of matrix multiplication (SGEMM). All the code for this benchmark can be found in the cuNumeric.jl/pkg/benchmark directory.","category":"page"},{"location":"benchmark/#Weak-Scaling-of-SGEMM","page":"Benchmarking","title":"Weak Scaling of SGEMM","text":"","category":"section"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"In this benchmark we will try to understand the weak scaling behavior of the SGEMM kernel (Float32 MatMul). To get started we need to decide our initial problem size, N and create some arrays. Note depending on the choice of N, Legate may decide to schedule your tasks on the CPU or GPU or both. We will also define two functions, total_flops and total_space which will help us calculate some useful benchmark metrics.","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"using cuNumeric\n\nN = 10_000\n\nfunction initialize_cunumeric(N)\n    A = cuNumeric.as_type(cuNumeric.rand(NDArray, N,N), LegateType(Float32))\n    B = cuNumeric.as_type(cuNumeric.rand(NDArray, N,N), LegateType(Float32))\n    C = cuNumeric.zeros(Float32, N, N)\n    return A, B, C\nend\n\nfunction total_flops(N)\n    return N * N * ((2*N) - 1)\nend\n\nfunction total_space(N)\n    return 3 * (N^2) * sizeof(Float32)\nend","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"We cannot use rely on common benchmark tools in Julia like BenchmarkTools.jl or ChairMarks.jl or even the built in Base.@time macro. The asynchronous nature of operations on NDArrays means that function calls will execute almost immediately and program execution must be blocked to properly time a kernel. It is technically possible to time NDArray operations with something like BenchmarkTools.jl by adding a blocking operation (e.g., accessing the result), but the allocations reported by these tools will never be correct and it is safer to use the timing functionality from CuPyNumeric. ","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"The timer built into CuPyNumeric blocks execution until all Legate operations preceding the call that generated the timing object complete. We provide two timing utilities: get_time_microseconds and get_time_nanoseconds. ","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"Now we can write the benchmark code. There are two more parameters we need to set: the number of samples, n_samples, and the number of warm-up samples, n_warnup. With all this the benchmark loop is:","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"using LinearAlgebra \n\nfunction gemm_cunumeric(N, n_samples, n_warmup)\n  A,B,C = initialize_cunumeric(N)\n\n  start_time = nothing\n  for idx in range(1, n_samples + n_warmup)\n    # Don't start the timer until warm-up is done\n    if idx == warmup + 1\n        start_time = get_time_microseconds()\n    end\n  \n    mul!(C, A, B)\n        \n  end\n  total_time_μs = get_time_microseconds() - start_time\n  mean_time_ms = total_time_μs / (n_samples * 1e3)\n  gflops = total_flops(N) / (mean_time_ms * 1e6) # GFLOP is 1e9\n\n  return mean_time_ms, gflops\nend\n\nn_samples = 10\nn_warmup = 2\n\nmean_time_ms, gflops = gemm_cunumeric(N, n_samples, n_warmup)","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"Since there is no programatic way to set the hardware configuration we must manipulate the environment variables described in Setting Hardware Configuration through shell scripts to make a weak scaling plot. These variables must be set before we launch the Julia runtime where we will run our benchmark. Therefore, I do not recommend generating scaling plots from the REPL because you would have to start and stop the REPL each time to re-configure the hardware settings. To make benchmarking easier, we provide a small shell script, run_benchmark.sh, located in cuNumeric.jl/pkg/benchmark. This script will automatically set the LEGATE_CONFIG according to the passed flags and run the specified benchmark file.","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"The first time using this script it is important to set the memory configuration which is currently hard coded in run_benchmark.sh where LEGATE_CONFIG is exported. We recommend using the memory configuration which is automatically chosen by Legate. It is also important to note that run_benchmark.sh assumes the environment containing cuNumeric.jl is at the relative path .. as hardcoded in the variable CMD (this is correct if you did not move files around). If your cuNumeric.jl environment is different be sure to update the path in run_benchmark.sh.","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"We have placed the SGEMM example from above into a Julia file called sgemm.jl located in the cuNumeric.jl/pkg/benchmark directory. Your cuNumeric environment can also be set by adding the following to sgemm.jl:","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"using Pkg\nPkg.activate(\"<path-to-cunumeric-env>\")","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"We also added the three lines to parse our settings from the command line so that we do not have to open the file to edit the settings each time.","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"N = parse(Int, ARGS[1])\nn_samples = parse(Int, ARGS[2])\nn_warmup = parse(Int, ARGS[3])","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"To run the benchmark simply run the following command with your settings.","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"./run_benchmark.sh sgemm.jl --cpus <n-cpus> --gpus <n-gpus> <N> <n_samples> <n_warmup>","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"Successful completion of one run should look like:","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"./run_benchmark.sh sgemm.jl --cpus 1 --gpus 1 10000 10 2\nRunning sgemm.jl with 1 CPUs and 1 GPUs\nRunning: julia --project='..' sgemm.jl 10000 10 2\n[ Info: Starting Legate\nLegate hardware configuration: --cpus=1 --gpus=1 --omps=1 --ompthreads=3 --utility=2 --sysmem=256 --numamem=19029 --fbmem=7569 --zcmem=128 --regmem=0\n[ Info: Started Legate successfully\n[ Info: Running MATMUL benchmark on 10000x10000 matricies for 10 iterations, 2 warmups\ncuNumeric Mean Run Time: 310.1302 ms\ncuNumeric FLOPS: 6448.581918175012 GFLOPS\n[ Info: Cleaning Up Legate","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"To generate a weak scaling plot, you must increment the problem size in proportion to the number of GPUs. This helps reveal any communication overhead in our SGEMM implementation since data may be transfered between GPUs or even across nodes in a server.","category":"page"},{"location":"benchmark/","page":"Benchmarking","title":"Benchmarking","text":"OUR RESULTS COMING SOON","category":"page"},{"location":"#cuNumeric.jl","page":"Home","title":"cuNumeric.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: Documentation dev) (Image: Build status) (Image: codecov) (Image: License: MIT)","category":"page"},{"location":"","page":"Home","title":"Home","text":"The cuNumeric.jl package wraps the CuPyNumeric C++ API from NVIDIA to bring simple distributed computing on GPUs and CPUs to Julia! We provide a simple array abstraction, the NDArray, which supports most of the operations you would expect from a normal Julia array.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This project is in alpha and we do not commit to anything necessarily working as you would expect. The current build process requires several external dependencies which are not registered on BinaryBuilder.jl yet. The build instructions and minimum pre-requesites are as follows:","category":"page"},{"location":"#Minimum-prereqs","page":"Home","title":"Minimum prereqs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"g++ capable of C++20\nCUDA 12.2\nPython 3.10\nUbuntu 20.04 or RHEL 8\nJulia 1.10\nCMake 3.26.4 ","category":"page"},{"location":"#1.-Download-[cuPyNumeric](https://github.com/nv-legate/cupynumeric/tree/branch-24.11)","page":"Home","title":"1. Download cuPyNumeric","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"conda create --name myenv \nconda activate myenv\nCONDA_OVERRIDE_CUDA=\"12.2\" \\\n  conda install -c conda-forge -c legate cupynumeric","category":"page"},{"location":"#2.-Install-Julia-through-[JuliaUp](https://github.com/JuliaLang/juliaup)","page":"Home","title":"2. Install Julia through JuliaUp","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"curl -fsSL https://install.julialang.org | sh -s -- --default-channel 1.10","category":"page"},{"location":"","page":"Home","title":"Home","text":"This will install version 1.10 by default since that is what we have tested against. To verify 1.10 is the default run either of the following (your may need to source bashrc):","category":"page"},{"location":"","page":"Home","title":"Home","text":"juliaup status\njulia --version","category":"page"},{"location":"","page":"Home","title":"Home","text":"If 1.10 is not your default, please set it to be the default. Newer versions of Julia are untested.","category":"page"},{"location":"","page":"Home","title":"Home","text":"juliaup default 1.10","category":"page"},{"location":"#3.-Get-latest-version-of-[libcxxwrap](https://github.com/JuliaInterop/libcxxwrap-julia)","page":"Home","title":"3. Get latest version of libcxxwrap","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"These commands simply download an external dependency used to wrap the CuPyNumeric C++ API.","category":"page"},{"location":"","page":"Home","title":"Home","text":"git submodule init\ngit submodule update","category":"page"},{"location":"#4.-Build-Julia-Package","page":"Home","title":"4. Build Julia Package","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This command must be run form the root of the repository. The progress of this command is piped into ./pkg/deps/build.log. It may take a few minutes to compile.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia -e 'using Pkg; Pkg.activate(\"./pkg\"); Pkg.resolve(); Pkg.build()'","category":"page"},{"location":"#5.-Test-the-Julia-Package","page":"Home","title":"5. Test the Julia Package","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This command must be run form the root of the repository.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia -e 'using Pkg; Pkg.activate(\"./pkg\"); Pkg.resolve(); Pkg.test()'","category":"page"},{"location":"","page":"Home","title":"Home","text":"With everything working, its the perfect time to checkout some of our examples!","category":"page"},{"location":"#TO-DO-List-of-Missing-Important-Features","page":"Home","title":"TO-DO List of Missing Important Features","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Full slicing support\nImplement unary_reduction over arbitrary dims\nOut-parameter binary_op\nReplace as_type with Base.convert\nInteger powers (e.g x^3)\nSupport Ints on methods that takes floats\nProgramatic manipulation of Legate hardware config (not currently possible)\nFloat32 random number generation (not possible in current C++ API)\nNormal random numbers (not possible in current C++ API)\nAdd Aqua.jl to CI to ensure we didn't pirate any types\nFix CodeCov reports\nFix cuNumeric.jl error in CI (requires unreleased CuPyNumeric)\nMove external packages to BinaryBuilder.jl (requires Legate open source)","category":"page"},{"location":"#Custom-install","page":"Home","title":"Custom install","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Optional: You can create a file called .localenv in order to add anything to the path. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"source ENV will setup the enviroment variables and source optional .localenv","category":"page"},{"location":"","page":"Home","title":"Home","text":"sh scripts/install_cxxwrap.sh  builds the Julia CXX wrapper https://github.com/JuliaInterop/libcxxwrap-julia","category":"page"},{"location":"","page":"Home","title":"Home","text":"sh scripts/legion_redop_patch.inl patches Legion https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md","category":"page"},{"location":"","page":"Home","title":"Home","text":"sh ./build.sh will create libcupynumericwrapper.so in $CUNUMERIC_JL_HOME/build","category":"page"},{"location":"#Contact","page":"Home","title":"Contact","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"For technical questions, please either contact  krasow(at)u.northwestern.edu OR emeitz(at)andrew.cmu.edu","category":"page"},{"location":"","page":"Home","title":"Home","text":"If the issue is building the package, please include the build.log and env.log found in cuNumeric.jl/pkg/deps/ ","category":"page"},{"location":"perf/#Performance-Tips","page":"Performance Tips","title":"Performance Tips","text":"","category":"section"},{"location":"perf/#Avoid-Scalar-Indexing","page":"Performance Tips","title":"Avoid Scalar Indexing","text":"","category":"section"}]
}
