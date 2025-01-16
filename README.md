# cuNumeric.jl
 
This is a Julia wrapper using [libcxxwrap](https://github.com/JuliaInterop/libcxxwrap-julia) for [cupynumeric](https://github.com/nv-legate/cupynumeric).

## Minimum prereqs
- g++ capable of C++20
- CUDA 12.2
- Python 3.10
- Ubuntu 20.04 or RHEL 8
- Julia 1.10
- CMake 3.26.4 

#### Download cupynumeric 

```bash 
conda create --name myenv 
conda activate myenv
CONDA_OVERRIDE_CUDA="12.2" \
  conda install -c conda-forge -c legate cupynumeric
```

#### Install Julia through [JuliaUp](https://github.com/JuliaLang/juliaup)
`curl -fsSL https://install.julialang.org | sh`

#### Get latest version of [libcxxwrap](https://github.com/JuliaInterop/libcxxwrap-julia)
```bash
git submodule init
git submodule update
```

#### Run the build script from the root of the repository
```julia
# Progress is piped into pkg/deps/build.log
julia -e 'using Pkg; Pkg.activate("./pkg"); Pkg.resolve(); Pkg.build()'
```

#### test the Julia package
```julia
julia -e 'using Pkg; Pkg.activate("./pkg"); Pkg.resolve(); Pkg.test()'
```

## Examples
```julia
using cuNumeric

arr = cuNumeric.rand(3, 3)

α = 1.32
b = 2.0

arr2 = α*arr + b # does this allocate 1 or 2 new NDArrays
arr2[:,:] # the current syntax for collecting all values and printing
```

## custom install

Optional: You can create a file called `.localenv` in order to add anything to the path. 

`source ENV` will setup the enviroment variables and source optional `.localenv`

`sh scripts/install_cxxwrap.sh`  builds the Julia CXX wrapper https://github.com/JuliaInterop/libcxxwrap-julia

`sh scripts/legion_redop_patch.inl` patches Legion https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md

`sh ./build.sh` will create `libcupynumericwrapper.so` in `$CUNUMERIC_JL_HOME/build`


## Sketchy Things We Should fix
- `cuNumeric.rand` overwrites all calls to Random.rand unless you specify the type (e.g. `rand(Float32, 2)`).  CUDA.jl has this implemented correctly.
-

## Contact
For technical questions, please either contact 
`krasow(at)u.northwestern.edu` OR
`emeitz(at)andrew.cmu.edu`

If the issue is building the package, please include the `build.log` and `env.log` found in `cuNumeric.jl/pkg/deps/` 
