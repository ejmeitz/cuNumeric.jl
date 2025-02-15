# Build Options

To make customization of the build options easier we have the `CNPreferences.jl` package to generate the `LocalPreferences.toml` which is read by the build script to determine which build option to use. CNPreferences.jl will also enforce that Julia is restarted for changes to take effect. This module is not needed by the default build path or once your `LocalPreferences.toml` is configured.

## Default Build (Conda.jl)

By default cuNumeric.jl will use [Conda.jl](https://github.com/JuliaPy/Conda.jl) to install cupynumeric inside of your `.julia` folder. By default this creates an environment called cupynumeric. To use this build option simply run:

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


### BinaryBuilder

This approach is not implemented yet. We hope to have this feature soon!



