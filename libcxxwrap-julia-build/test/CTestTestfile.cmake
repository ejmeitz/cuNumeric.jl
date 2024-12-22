# CMake generated Testfile for 
# Source directory: /home/david/cuNumeric.jl/libcxxwrap-julia/test
# Build directory: /home/david/cuNumeric.jl/libcxxwrap-julia-build/test
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(test_module "/home/david/cuNumeric.jl/libcxxwrap-julia-build/test/test_module")
set_tests_properties(test_module PROPERTIES  ENVIRONMENT "JULIA_HOME=/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/bin" _BACKTRACE_TRIPLES "/home/david/cuNumeric.jl/libcxxwrap-julia/test/CMakeLists.txt;9;add_test;/home/david/cuNumeric.jl/libcxxwrap-julia/test/CMakeLists.txt;0;")
add_test(test_type_init "/home/david/cuNumeric.jl/libcxxwrap-julia-build/test/test_type_init")
set_tests_properties(test_type_init PROPERTIES  ENVIRONMENT "JULIA_HOME=/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/bin" _BACKTRACE_TRIPLES "/home/david/cuNumeric.jl/libcxxwrap-julia/test/CMakeLists.txt;13;add_test;/home/david/cuNumeric.jl/libcxxwrap-julia/test/CMakeLists.txt;0;")
add_test(test_cxxwrap "/home/david/cuNumeric.jl/libcxxwrap-julia-build/test/test_cxxwrap")
set_tests_properties(test_cxxwrap PROPERTIES  ENVIRONMENT "JULIA_HOME=/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/bin" _BACKTRACE_TRIPLES "/home/david/cuNumeric.jl/libcxxwrap-julia/test/CMakeLists.txt;17;add_test;/home/david/cuNumeric.jl/libcxxwrap-julia/test/CMakeLists.txt;0;")
