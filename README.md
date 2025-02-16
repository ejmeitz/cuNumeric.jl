# cuNumeric.jl

[![Documentation dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ejmeitz.github.io/cuNumeric.jl/dev)
[![Build status](https://ci.appveyor.com/api/projects/status/973jtue9itgvvlc7?svg=true)](https://ci.appveyor.com/project/ejmeitz/cunumeric-jl)
[![codecov](https://codecov.io/github/ejmeitz/cuNumeric.jl/branch/main/graph/badge.svg)](https://app.codecov.io/github/ejmeitz/cuNumeric.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

The cuNumeric.jl package wraps the [CuPyNumeric](https://github.com/nv-legate/cupynumeric) C++ API from NVIDIA to bring simple distributed computing on GPUs and CPUs to Julia! We provide a simple array abstraction, the `NDArray`, which supports most of the operations you would expect from a normal Julia array.

This project is in alpha and we do not commit to anything necessarily working as you would expect. The current build process requires several external dependencies which are not registered on BinaryBuilder.jl yet. The build instructions and minimum pre-requesites are as follows:

## Minimum prereqs
- g++ capable of C++20
- CUDA 12.2
- Python 3.10
- Ubuntu 20.04 or RHEL 8
- Julia 1.10
- CMake 3.26.4 

### 1. Install Julia through [JuliaUp](https://github.com/JuliaLang/juliaup)
```
curl -fsSL https://install.julialang.org | sh -s -- --default-channel 1.10
```

This will install version 1.10 by default since that is what we have tested against. To verify 1.10 is the default run either of the following (your may need to source bashrc):
```bash
juliaup status
julia --version
```

If 1.10 is not your default, please set it to be the default. Other versions of Julia are untested.
```bash
juliaup default 1.10
```

### 2. Download cuNumeric.jl
cuNumeric.jl is not on the general registry yet. To add cuNumeric.jl to your environment run:
```julia
using Pkg; Pkg.add(url = "https://github.com/ejmeitz/cuNumeric.jl", rev = "main")
```

The `rev` option can be main or any tagged version.

### 3. Test the Julia Package
Run this command in the Julia environment where cuNumeric.jl is installed.
```julia
using Pkg; Pkg.test("cuNumeric")
```

With everything working, its the perfect time to checkout some of our [examples](https://ejmeitz.github.io/cuNumeric.jl/dev/examples/)!


## Custom Installs and Development
See the [Custom Builds](https://ejmeitz.github.io/cuNumeric.jl/dev/install/) section of the documentation to build cuNumeric.jl with a local conda environment providing the cupynumeric binaries. 

To re-build `cuNumeric.jl` with a local environment run the following command. The progress of the build is piped into `./pkg/deps/build.log`. It may take a few minutes to compile.
```julia
julia -e 'using Pkg; Pkg.activate("./pkg"); Pkg.resolve(); Pkg.build()'
```


## TO-DO List of Missing Important Features
- Full slicing support
- Implement `unary_reduction` over arbitrary dims
- Out-parameter `binary_op`
- Replace `as_type` with `Base.convert`
- Integer powers (e.g x^3)
- Support Ints on methods that takes floats
- Programatic manipulation of Legate hardware config (not currently possible)
- Float32 random number generation (not possible in current C++ API)
- Normal random numbers (not possible in current C++ API)
- Add Aqua.jl to CI to ensure we didn't pirate any types
- Fix CodeCov reports
- Fix cuNumeric.jl error in CI (requires unreleased CuPyNumeric)
- Move external packages to [BinaryBuilder.jl](https://docs.binarybuilder.org/stable/) (requires Legate open source)

## Contact
For technical questions, please either contact 
`krasow(at)u.northwestern.edu` OR
`emeitz(at)andrew.cmu.edu`

If the issue is building the package, please include the `build.log` and `.err` files found in `cuNumeric.jl/pkg/deps/` 

