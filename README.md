# cuNumeric.jl
 
This is a Julia wrapper using libcxxwrap (https://github.com/JuliaInterop/libcxxwrap-julia) for cupynumeric (https://github.com/nv-legate/cupynumeric).

## Minimum prereqs
- g++ capable of C++20
- CUDA 12.2
- Python 3.10
- Ubuntu 20.04 or RHEL 8
- Julia 1.10

### download Julia 
`curl -fsSL https://install.julialang.org | sh`

## git submodules
```bash
git submodule init
git submodule update

```
## setup env 
Optional: You can create a file called `.localenv` in order to add anything to the path. 

`source ENV` will setup the enviroment variables and source optional `.localenv`

## install packages
`sh scripts/install_cxxwrap.sh`

## patch legion
`sh scripts/legion_redop_patch.inl`

## build wrapper
`sh ./build.sh`



## Wish List / Question
- Add public typedefs for template parameters in FieldAccessor/AccessorRO/AccessorWO so we can generate templated functions that use these classes
- Where is MachineQueryInterface abstract interface implemented? Would be nice to have access to cpus(), gpus() etc. info
    - Is there a way to use CuPyNumericRuntime to access this? legate_runtime_ is private
        so no access to machine info that legate found
