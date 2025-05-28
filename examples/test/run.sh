export PATH=/home/david/FlameGraph:$PATH
ENABLE_JITPROFILING=1  perf record -F 99 -g julia --project="." ccall_gc.jl 
perf script > out_c.perf
stackcollapse-perf.pl out_c.perf > out_c.folded
flamegraph.pl out_c.folded > kernel_c.svg

ENABLE_JITPROFILING=1  perf record -F 99 -g julia --project="." cxxwrap_gc.jl 
perf script > out_cxx.perf
stackcollapse-perf.pl out_cxx.perf > out_cxx.folded
flamegraph.pl out_cxx.folded > kernel_cxx.svg


ENABLE_JITPROFILING=1  perf record -F 99 -g julia --project="." default_gc.jl 
perf script > out_default.perf
stackcollapse-perf.pl out_default.perf > out_default.folded
flamegraph.pl out_default.folded > kernel_default.svg
