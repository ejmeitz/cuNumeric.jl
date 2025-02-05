# Build Options

By default `cuNumeric.jl` will install cupynumeric with [Conda.jl](https://github.com/JuliaPy/Conda.jl) into a new conda environment stored inside the `.julia/conda` directory.

To customize the build process create a `LocalPreferences.toml` file in the same directory as the `Project.toml` where `cuNumeric.jl` is installed (or in the cuNumeric.jl git repo).

 The `LocalPreferences.toml` defines 3 keys : `mode`, `conda_jl_env`,  and `user_env`.

The `mode` option can be either: 
- "local_env" : cuNumeric.jl will link against a local install of cupynumeric
- "conda_jl" : cuNumeric.jl will use Conda.jl to install cupynumeric

When `mode` is set to `local_env` the `user_env` option must be defined as the absolute path to the conda environment with cupynumeric installed (e.g., the value of CONDA_PREFIX when your environment is active). For me this path is: `/home/emeitz/.conda/envs/cunumeric-gpu`.

The `conda_jl` mode only needs to be set if you previously used a local environment and want to switch back to a Conda.jl install. The `conda_jl_env` key will set the name of the environment created by Conda.jl, by default this is just cupynumeric.

The `LocalPreferences.toml` might look like:

```
[cuNumeric]
mode = "local_env"
conda_jl_env = "cupynumeric"
user_env = "/home/emeitz/.conda/envs/cunumeric-gpu"
```

After setting the `LocalPreferences.toml` you must re-build cuNumeric.jl by running:
```julia
julia -e 'using Pkg; Pkg.build()'
```

## Using Local CUDA

A common reason to link against an existing environment is to avoid cupynumeric re-installing the entire CUDA toolkit. To make your own conda environment built off an existing CUDA install run the following with whatever version of CUDA is on the `LD_LIBRARY_PATH` in place of 12.2.

```bash 
conda create --name myenv 
conda activate myenv
CONDA_OVERRIDE_CUDA="12.2" \
  conda install -c conda-forge -c legate cupynumeric
```



