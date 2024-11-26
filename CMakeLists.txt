
cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)

# Set the project name
project(cuNumericWrapper VERSION 0.01 LANGUAGES CXX)

# Specify C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)



# Assuming CUNUMERIC_LIB_PATH is an environment variable or predefined
set(CUNUMERIC_PATH "/home/emeitz/.conda/envs/cunumeric")
set(LIBCUNUMERIC_PATH ${CUNUMERIC_PATH}/lib) 
set(LIBCUNUMERIC_NAME "libcupynumeric.so")

set(CXXWRAP_PATH "/home/emeitz/software/libcxxwrap-julia")
set(LIBCXXWRAP_PATH ${CXXWRAP_PATH}/lib)
set(LIBCXXWRAP_NAME "libcxxwrap_julia.so")

set(JULIA_DIR "/home/emeitz/.julia/juliaup/julia-1.10.0+0.x64.linux.gnu")

# Include the header files
include_directories(
                    ${CXXWRAP_PATH}/include
                    ${CUNUMERIC_PATH}/include
                    ${CUNUMERIC_PATH}/include/legate
                    ${JULIA_DIR}/include/julia
                    )


# Load cunumeric and legate libraries 
add_library(cuPyNumeric SHARED IMPORTED)
set_property(TARGET cuPyNumeric PROPERTY IMPORTED_LOCATION ${LIBCUNUMERIC_PATH}/${LIBCUNUMERIC_NAME})

add_library(cxxwrap_julia SHARED IMPORTED)
set_property(TARGET cxxwrap_julia PROPERTY IMPORTED_LOCATION ${LIBCXXWRAP_PATH}/${LIBCXXWRAP_NAME})


# Create the shared library that wraps the cunumeric/legate libs
set(SOURCES wrapper/wrapper.cpp)
add_library(cuNumericWrapper SHARED ${SOURCES})

# Create executable which tests the cpp interface 
# that the shared library is wrapping/exposing to Julia
add_executable(cunumeric_cpp_test wrapper/test.cpp) 
target_link_libraries(cunumeric_cpp_test PRIVATE cuNumericWrapper) # link my library to the test executable


# Optionally, install the library and header
#* probably should set the install paths to something else
install(TARGETS cuNumericWrapper DESTINATION ./lib)
