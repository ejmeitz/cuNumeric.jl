module CNPreferences

using Preferences

const PREFS_CHANGED = Ref(false)
const DEPS_LOADED = Ref(false)

const CONDA_JL_MODE = "conda_jl"
const LOCAL_CONDA_MODE = "local_env"
const DEFAULT_ENV_NAME = "cupynumeric"

# Store what the values were when module loaded
const user_env = @load_preference("user_env")
const conda_jl_env = @load_preference("conda_jl_env")
const mode = @load_preference("mode")

# from MPIPreferences.jl
"""
    CNPreferences.check_unchanged()

Throws an error if the preferences have been modified in the current Julia
session, or if they are modified after this function is called.

This is should be called from the `__init__()` function of any package which
relies on the values of CNPreferences.
"""
function check_unchanged()
    if PREFS_CHANGED[]
        error("CNPreferences have changed, you will need to restart Julia for the changes to take effect")
    end
    DEPS_LOADED[] = true
    return nothing
end

"""
    CNPreferences.use_existing_conda_env(env_path::String; export_prefs = false, force = true)

Tells cuNumeric.jl to link the C++ wrapper against an existing cupynumeric install. We make
no gurantees of compiler compatability at this time. The compiler used to link the C++ wrapper
is the `cmake` on path.

Expects `env_path` to be the absolute path to the root of the environment.
For example, `/home/emeitz/.conda/envs/cunumeric-gpu`
"""
function use_existing_conda_env(env_path::String; export_prefs = false, force = true)

    set_preferences!(CNPreferences,
        "user_env" =>  env_path,
        "mode" => LOCAL_CONDA_MODE,
        export_prefs = export_prefs,
        force = force
    )

    if env_path == CNPreferences.user_env && CNPreferences.mode == LOCAL_CONDA_MODE
        @info "CNPreferences found no differences."
    else
        PREFS_CHANGED[] = true
        @info "CNPreferences set to use local conda env at:" env_path

        if DEPS_LOADED[]
            error("You will need to restart Julia for the changes to take effect")
        end
    end

end

"""
    CNPreferences.use_conda_jl([env_name::String]; export_prefs = false, force = true)

Tells cuNumeric.jl to install cupynumeric with Conda.jl. The environment created or re-used will have 
name `env_name` which by default is cupynumeric. If this environment does not exist it will be created
and cupynumeric will be installed. Once installed, this version of cupynumeric will be used to link
the C++ wrapper library. This install will rely on the automatic configuration of cupynumeric and 
could install cuda toolkit into the conda environment.

Expects `env_name` to just be the name of the environment. For example, `cunumeric-gpu`.
"""
function use_conda_jl(env_name::String = DEFAULT_ENV_NAME; export_prefs = false, force = true)

    set_preferences!(CNPreferences,
        "conda_jl_env" =>  env_name,
        "mode" => CONDA_JL_MODE,
        export_prefs = export_prefs,
        force = force
    )

    if env_name == CNPreferences.conda_jl_env && CNPreferences.mode == CONDA_JL_MODE
        @info "CNPreferences found no differences."
    else
        PREFS_CHANGED[] = true
        @info "CNPreferences set to use Conda.jl with env name:" env_name

        if DEPS_LOADED[]
            error("You will need to restart Julia for the changes to take effect")
        end
    end
end

function use_jll_binary()
    error("This package is not available on binary builder yet")
end

end
