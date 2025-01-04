export LegateSettings

# From https://github.com/JuliaGraphics/QML.jl/blob/dca239404135d85fe5d4afe34ed3dc5f61736c63/src/QML.jl#L147
mutable struct ArgcArgv
    argv
    argc::Cint
  
    function ArgcArgv(args::Vector{String})
      argv = Base.cconvert(CxxPtr{CxxPtr{CxxChar}}, args)
      argc = length(args)
      return new(argv, argc)
    end
  end
  
getargv(a::ArgcArgv) = Base.unsafe_convert(CxxPtr{CxxPtr{CxxChar}}, a.argv)

#######################################

@enum Launchers mpirun jsrun srun none not_passed

# Just assuming the args here are the same that cupynumeric
#  expects when initializing legate
# https://docs.nvidia.com/legate/latest/usage.html#resource-allocation
Base.@kwdef mutable struct LegateSettings
  cpus::Int = -1 # how many individual CPU threads are spawned
  omps::Int = -1 # how many OpenMP groups are spawned
  ompthreads::Int = -1 # how many threads are spawned per OpenMP group
  gpus::Int = -1 # how many GPUs are used

  nodes::Int = -1 # number of nodes to use
  launcher::Launchers = not_passed # program to spawn processes (e.g. mpirun)

  # Also memory options, but I'm just going to let Legate
  # do that until someone asks for that feature
end

Base.keys(::LegateSettings) = fieldnames(LegateSettings)

# Returns as list of strings (how argv expects minus prog name)
function make_cmd(ls::LegateSettings)
  cmd = ""

  if ls.nodes > 0 && ls.launcher != not_passed
    cmd *= "--nodes $(ls.nodes) --launcher $(String(Symbol(ls.launcher))) "
  elseif ls.nodes > 0 && ls.launcher == not_passed
    throw("Asked for $(ls.nodes) nodes but did not pass a launcher.")
  end

  if ls.cpus > 0
    cmd *= "--cpus $(ls.cpus) "
  end

  if ls.gpus > 0
    cmd *= "--gpus $(ls.gpus) "
  end

  if ls.omps > 0
    cmd *= "--omps $(ls.omps) "
  end

  if ls.ompthreads > 0
    cmd *= "--ompthreads $(ls.ompthreads) "
  end

  return String.(split(cmd[1:end-1]))
end

# Parse from LocalPreferences.toml if it exists
# These are the settings used inside __init__ 
# to start legate the first time
function get_initial_legate_settings()
  settings = LegateSettings()

  for opt in keys(settings)
    default = getfield(settings, opt)
    if opt == :launcher
      pref_symbol = Symbol(@load_preference(String(opt), default))
      setfield!(settings, opt, eval(pref_symbol))
    else
      setfield!(settings, opt, @load_preference(String(opt), default))
    end
  end
  println(settings)
  return make_cmd(settings)
end

function Base.show(io::IO, ls::LegateSettings)
  if ls.nodes > 0 && ls.launcher != not_passed
    println("$(ls.nodes) nodes with $(String(Symbol(ls.launcher)))")
  end

  if ls.cpus > 0
    println("CPUs: $(ls.cpus)")
  end

  if ls.gpus > 0
    println("GPUs: $(ls.gpus)")
  end

  if ls.omps > 0
    println("OMPs: $(ls.omps)")
  end

  if ls.ompthreads > 0
    println("OMP Threads: $(ls.ompthreads)")
  end
end

function legate_capabilities()
  #output from legate --info
  # HOW???
end
