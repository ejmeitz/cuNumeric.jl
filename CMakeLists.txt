
cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)

# Set the project name
project(cuNumericWrapper VERSION 0.01 LANGUAGES CXX)

# Specify C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Not sure this will work if cupynumeric uses CUDA in a conda env
find_package(CUDAToolkit REQUIRED)
# target_link_libraries(cuNumericWrapper PRIVATE CUDA::cudart)

# Assuming CUNUMERIC_LIB_PATH is an environment variable or predefined
set(CUNUMERIC_PATH "/home/emeitz/.conda/envs/cunumeric")
set(LIBCUNUMERIC_PATH ${CUNUMERIC_PATH}/lib) 
set(LIBCUNUMERIC_NAME "libcupynumeric.so")
set(LIBLEGATE_NAME "liblegate.so")

set(CXXWRAP_PATH "/home/emeitz/software/libcxxwrap-julia")
set(LIBCXXWRAP_PATH ${CXXWRAP_PATH}/lib)
set(LIBCXXWRAP_NAME "libcxxwrap_julia.so")

# This needs to be whatever Julia was given to libcxx_wrap
set(JULIA_DIR "/home/emeitz/.julia/juliaup/julia-1.10.0+0.x64.linux.gnu")


# Make cunumeric, legate and cxxwrap libraries 
#* use RPATH?
add_library(cuPyNumeric SHARED IMPORTED)
set_property(TARGET cuPyNumeric PROPERTY IMPORTED_LOCATION ${LIBCUNUMERIC_PATH}/${LIBCUNUMERIC_NAME})

add_library(cxxwrap_julia SHARED IMPORTED)
set_property(TARGET cxxwrap_julia PROPERTY IMPORTED_LOCATION ${LIBCXXWRAP_PATH}/${LIBCXXWRAP_NAME})

add_library(legate SHARED IMPORTED)
set_property(TARGET legate PROPERTY IMPORTED_LOCATION ${LIBCUNUMERIC_PATH}/${LIBLEGATE_NAME})


# Create the shared library that wraps the cunumeric/legate libs
set(SOURCES wrapper/wrapper.cpp)
add_library(cuNumericWrapper SHARED ${SOURCES})

#* necessary??
target_link_libraries(cuNumericWrapper PRIVATE
                         cuPyNumeric 
                         legate
                         cxxwrap_julia
                    )

# Include the header files
target_include_directories(cuNumericWrapper PRIVATE
                    ${CUDAToolkit_INCLUDE_DIRS}
                    ${CXXWRAP_PATH}/include
                    ${CUNUMERIC_PATH}/include
                    ${CUNUMERIC_PATH}/include/cupynumeric
                    ${CUNUMERIC_PATH}/include/legate
                    ${JULIA_DIR}/include/julia
                    )

# Create executable which tests the cpp interface 
# that the shared library is wrapping/exposing to Julia
add_executable(cunumeric_cpp_test wrapper/test.cpp) 
target_link_libraries(cunumeric_cpp_test INTERFACE cuNumericWrapper) # link my library to the test executable

#* probably should set the install paths to something else
install(TARGETS cuNumericWrapper DESTINATION ./lib)
