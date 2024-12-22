#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "JlCxx::cxxwrap_julia" for configuration ""
set_property(TARGET JlCxx::cxxwrap_julia APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(JlCxx::cxxwrap_julia PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libcxxwrap_julia.so.0.14.0"
  IMPORTED_SONAME_NOCONFIG "libcxxwrap_julia.so.0"
  )

list(APPEND _cmake_import_check_targets JlCxx::cxxwrap_julia )
list(APPEND _cmake_import_check_files_for_JlCxx::cxxwrap_julia "${_IMPORT_PREFIX}/lib/libcxxwrap_julia.so.0.14.0" )

# Import target "JlCxx::cxxwrap_julia_stl" for configuration ""
set_property(TARGET JlCxx::cxxwrap_julia_stl APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(JlCxx::cxxwrap_julia_stl PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libcxxwrap_julia_stl.so"
  IMPORTED_SONAME_NOCONFIG "libcxxwrap_julia_stl.so"
  )

list(APPEND _cmake_import_check_targets JlCxx::cxxwrap_julia_stl )
list(APPEND _cmake_import_check_files_for_JlCxx::cxxwrap_julia_stl "${_IMPORT_PREFIX}/lib/libcxxwrap_julia_stl.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
