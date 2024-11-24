cmake_minimum_required(VERSION 3.10)

# Set the project name
project(cuNumericWrapper)

# Specify C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)



# Assuming CUNUMERIC_LIB_PATH is an environment variable or predefined
set(CUNUMERIC_PATH "/home/emeitz/.conda/envs/cunumeric/")
set(LIBCUNUMERIC_PATH ${CUNUMERIC_PATH}/lib) 
set(LIBCUNUMERIC_NAME "libcupynumeric")

set (CXXWRAP_PATH "/home/emeitz/software/libcxxwrap-julia/lib")
set(LIBCXXWRAP_PATH ${CXXWRAP_PATH}/lib)
set(LIBCXXWRAP_NAME "libcxxwrap_julia")

# Include the header files
include_directories(${CXXWRAP_PATH}/include ${CUNUMERIC_PATH}/include)

# Add the source files
set(SOURCES wrapper/wrapper.cpp)


# Add the dependency to the shared library
add_library(cuPyNumeric SHARED IMPORTED)
target_link_libraries(cuPyNumeric PRIVATE ${LIBCUNUMERIC_PATH}/${LIBCUNUMERIC_NAME}.so)
set_target_properties(cuPyNumeric PROPERTIES INSTALL_RPATH "${CUNUMERIC_LIB_PATH}")

add_library(cxxwrap_julia SHARED IMPORTED)
target_link_libraries(cxxwrap_julia PRIVATE ${LIBCXXWRAP_PATH}/${LIBCXXWRAP_NAME}.so)
set_target_properties(cxxwrap_julia PROPERTIES INSTALL_RPATH "${CXXWRAP_LIB_PATH}")



# Create the shared library
add_library(cuNumericWrapper SHARED ${SOURCES})

# Optionally set the version of the shared library
set_target_properties(cuNumericWrapper PROPERTIES VERSION 1.0 SOVERSION 1)

# Optionally, install the library and headers
install(TARGETS cuNumericWrapper DESTINATION lib)
install(DIRECTORY include/ DESTINATION include)
