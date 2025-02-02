
cmake_minimum_required(VERSION 3.22.1 FATAL_ERROR)

project(cuNumericWrapper VERSION 0.01 LANGUAGES C CXX)

# Specify C++ standard
set(CMAKE_CXX_STANDARD_REQUIRED True)

if (NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

find_package(cupynumeric REQUIRED)


execute_process(
  COMMAND julia -e "println(DEPOT_PATH[1])"
  OUTPUT_VARIABLE JULIA_DEP_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# THERE IS NO INCLUDE DIR HERE???
set(JlCxx_DIR "${JULIA_DEP_PATH}/dev/libcxxwrap_julia_jll/override")
find_package(JlCxx)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")
message(STATUS "Found JlCxx at ${JlCxx_location}")


# Julia Wrapper Library
add_library(cupynumericwrapper SHARED
             wrapper/src/wrapper.cpp
             wrapper/src/types.cpp)

# both can be private I think
target_link_libraries(cupynumericwrapper 
                        PRIVATE cupynumeric::cupynumeric
                        PRIVATE legate::legate
                        PUBLIC JlCxx::cxxwrap_julia)


target_include_directories(cupynumericwrapper PRIVATE 
                            ${JULIA_PATH}/include/julia
                            wrapper/include
                        )

install(TARGETS cupynumericwrapper 
          DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-install")




######### C++ API TEST FILE ONLY ######################################
# Create executable which tests the cpp interface 		      #
# that the shared library is wrapping/exposing to Julia		      #
# add_executable(matmulfp32 wrapper/matmulfp32.cpp) 
# target_link_libraries(matmulfp32 PRIVATE cupynumeric::cupynumeric)
# install(TARGETS matmulfp32 DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/cmake-install")



