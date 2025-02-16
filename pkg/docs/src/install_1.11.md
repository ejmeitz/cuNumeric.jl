# Build Options

To make customization of the build options easier we have the `CNPreferences.jl` package to generate the `LocalPreferences.toml` which is read by the build script to determine which build option to use. CNPreferences.jl will also enforce that Julia is restarted for changes to take effect. This module is not needed by the default build path or once your `LocalPreferences.toml` is configured.

`CNPreferences` is a separate module so that it can be used to configure the build settings before `cuNumeric.jl` is added to your environment. To install it separately run

```julia
using Pkg; Pkg.add(url = "https://github.com/ejmeitz/cuNumeric.jl", subdir="lib/CNPreferences")
```

You can also avoid installing `CNPreferences` and manually manage your `LocalPreferences.toml`. The file should look something like this:

```
[CNPreferences]
conda_jl_env = "cupynumeric"
mode = "local_env"
user_env = "/home/emeitz/.conda/envs/cunumeric-gpu"
```

The mode can either be "local_env" or "conda_jl". If `mode` is set to "local_env" then `user_env` must be the absolute path to your local conda environment (e.g., the value of CONDA_PREFIX when your environment is active) and `conda_jl_env` will be ignored. If `mode` is set to `conda_jl` then Conda.jl is used to create an environment with the name set by `conda_jl_env`. By default, `conda_jl_env` is cupynumeric. 

## Default Build (Conda.jl)

By default cuNumeric.jl will use [Conda.jl](https://github.com/JuliaPy/Conda.jl) to install cupynumeric inside of your `.julia` folder. This will create an environment called cupynumeric. To use this build option simply run:

```
Pkg.add(url = "https://github.com/ejmeitz/cuNumeric.jl")
```

If you previously used a custom build and would like to revert back to using Conda.jl run the following command in the directory containing the Project.toml of your environment. The "Custom Builds" section discusses the CNPreferences module in more detail.

```julia
julia --project -e 'using CNPreferences; CNPreferences.use_conda_jl()'
```

## Link Against Existing Conda Environment

To update `LocalPreferences.toml` so that a local conda environment is used as the binary provider for cupynumeric run the following command. `env_path` should be the absolute path to the conda environment (e.g., the value of CONDA_PREFIX when your environment is active). For me this path is: `/home/emeitz/.conda/envs/cunumeric-gpu`.

```julia
julia --project -e 'using CNPreferences; CNPreferences.use_existing_conda_env("<env-path>")'
```

!!!note
    You might see the `conda_jl_env` key in your `LocalPreferences.toml` even if the mode is set to `local_env`. This is completely normal and is just a past setting that will be ignored.

A common reason to link against an existing environment is to avoid cupynumeric re-installing the entire CUDA toolkit. To make your own conda environment built off an existing CUDA install run the following with whatever version of CUDA is on the `LD_LIBRARY_PATH` in place of 12.2.

```bash 
conda create --name myenv 
conda activate myenv
CONDA_OVERRIDE_CUDA="12.2" \
  conda install -c conda-forge -c legate cupynumeric
```



### BinaryBuilder

This approach is not implemented yet. We hope to have this feature soon!



