# cuNumeric.jl
 
This is a Julia wrapper using libcxxwrap (https://github.com/JuliaInterop/libcxxwrap-julia) for cupynumeric (https://github.com/nv-legate/cupynumeric).

## Minimum prereqs
- g++ capable of C++20
- CUDA 12.2
- Python 3.10
- Ubuntu 20.04 or RHEL 8
- Julia 1.10

#### download cupynumeric 

```bash 
conda create --name myenv 
conda activate myenv
CONDA_OVERRIDE_CUDA="12.2" \
  conda install -c conda-forge -c legate cupynumeric
```

#### download Julia 
`curl -fsSL https://install.julialang.org | sh`

#### git submodules
```bash
git submodule init
git submodule update
```

## install with julia build
```julia
    pkg>  activate .
    pkg>  build
```

## test
```julia
    pkg>  test
```

## custom install

#### setup env 
Optional: You can create a file called `.localenv` in order to add anything to the path. 

`source ENV` will setup the enviroment variables and source optional `.localenv`

#### install packages
`sh scripts/install_cxxwrap.sh`

#### patch legion
`sh scripts/legion_redop_patch.inl`

#### build wrapper
`sh ./build.sh`



## Contact
For technical questions, please either contact 
krasow(at)u.northwestern.edu
emeitz(at)andrew.cmu.edu

If the issue is building the package, please include the `build.log` found in `cuNumeric.jl/pkg/deps/build.log`