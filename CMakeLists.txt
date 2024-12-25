
cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)

project(cuNumericWrapper VERSION 0.01 LANGUAGES C CXX)

# Specify C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED True)

if (NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

find_package(cupynumeric REQUIRED)

set(JlCxx_DIR "${CUNUMERIC_JL_HOME}libcxxwrap-julia-build")
find_package(JlCxx)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")
message(STATUS "Found JlCxx at ${JlCxx_location}")

# This needs to be whatever Julia was given to libcxx_wrap
# This is found when running find_package(JlCxx) can I just get it from there?

# Julia Wrapper Library
add_library(cupynumericwrapper SHARED wrapper/wrapper.cpp)

# both can be private I think
target_link_libraries(cupynumericwrapper 
                        PRIVATE cupynumeric::cupynumeric
                        PRIVATE legate::legate
                        PUBLIC JlCxx::cxxwrap_julia)


#NEEDED???
target_include_directories(cupynumericwrapper PRIVATE 
                            ${JULIA_PATH}/include/julia
                            ${JlCxx_DIR}/include
                        )

# Create executable which tests the cpp interface 
# that the shared library is wrapping/exposing to Julia
# add_executable(cunumeric_cpp_test wrapper/test.cpp) 
# target_link_libraries(cunumeric_cpp_test PRIVATE cupynumeric::cupynumeric)


install(TARGETS cupynumericwrapper 
          DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-install")

# install(TARGETS cunumeric_cpp_test DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-install")
