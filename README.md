# cuNumeric.jl
 



Notes to Self:


Build libcxxwrap-julia
- git clone https://github.com/JuliaInterop/libcxxwrap-julia.git
- cd libcxxwrap-julia.git
- cmake -DJulia_EXECUTABLE=/home/emeitz/.julia/juliaup/julia-1.10.0+0.x64.linux.gnu/bin/julia ./
    -`Julia_EXECUTABLE` is the full path to the julia.exe program


Build C++ Wrapper Library:
- activate conda environment cupynumeric is installed into
- ./build.sh
    - This runs CMake, you may need to change some paths inside the CMakeLists.txt file. Specifically, `CXXWRAP_DIR` which is root of the libcxxwrap-julia library and `JULIA_DIR` is the root directory of your julia install. 