# cuNumeric.jl
 



Notes to Self:


Build libcxxwrap-julia
- git clone https://github.com/JuliaInterop/libcxxwrap-julia.git
- cd libcxxwrap-julia.git
- cmake -DJulia_EXECUTABLE=/home/emeitz/.julia/juliaup/julia-1.10.0+0.x64.linux.gnu/bin/julia ./


Build C++ Wrapper Library:
- activate conda environment cupynumeric is installed into
- ./build.sh