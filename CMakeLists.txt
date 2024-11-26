
cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)

project(cuNumericWrapper VERSION 0.01 LANGUAGES C CXX)

# Specify C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED True)

if (NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

find_package(cupynumeric REQUIRED)


set(CXXWRAP_PATH "/home/emeitz/software/libcxxwrap-julia")
set(LIBCXXWRAP_PATH ${CXXWRAP_PATH}/lib)
set(LIBCXXWRAP_NAME "libcxxwrap_julia.so")

# This needs to be whatever Julia was given to libcxx_wrap
set(JULIA_DIR "/home/emeitz/.julia/juliaup/julia-1.10.0+0.x64.linux.gnu")


add_library(cxxwrap_julia SHARED IMPORTED)
set_property(TARGET cxxwrap_julia PROPERTY IMPORTED_LOCATION ${LIBCXXWRAP_PATH}/${LIBCXXWRAP_NAME})


# Julia Wrapper Library
add_library(cuNumericWrapper SHARED wrapper/wrapper.cpp)

#* necessary??
target_link_libraries(cuNumericWrapper PRIVATE
                         cupynumeric::cupynumeric
                         cxxwrap_julia
                    )
target_include_directories(cuNumericWrapper PRIVATE 
                            ${JULIA_DIR}/include/julia
                            ${CXXWRAP_PATH}/include
                        )

# Include the header files
# target_include_directories(cuNumericWrapper PRIVATE
#                     ${CUDAToolkit_INCLUDE_DIRS}
#                     ${CXXWRAP_PATH}/include
#                     ${CUNUMERIC_PATH}/include
#                     ${CUNUMERIC_PATH}/include/cupynumeric
#                     ${CUNUMERIC_PATH}/include/legate
#                     ${JULIA_DIR}/include/julia
#                     )

# Create executable which tests the cpp interface 
# that the shared library is wrapping/exposing to Julia
add_executable(cunumeric_cpp_test wrapper/test.cpp) 
target_link_libraries(cunumeric_cpp_test PRIVATE cupynumeric::cupynumeric)

install(TARGETS cuNumericWrapper DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-install")
install(TARGETS cunumeric_cpp_test DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-install")