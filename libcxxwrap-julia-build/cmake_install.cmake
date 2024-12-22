# Install script for directory: /home/david/cuNumeric.jl/libcxxwrap-julia

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia.so.0.14.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia.so.0"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libcxxwrap_julia.so.0.14.0"
    "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libcxxwrap_julia.so.0"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia.so.0.14.0"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia.so.0"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:::::::::::::::"
           NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libcxxwrap_julia.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/jlcxx" TYPE FILE FILES
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/array.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/attr.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/const_array.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/jlcxx.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/jlcxx_config.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/julia_headers.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/functions.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/module.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/smart_pointers.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/stl.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/tuple.hpp"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/type_conversion.hpp"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia_stl.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia_stl.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia_stl.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libcxxwrap_julia_stl.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia_stl.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia_stl.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia_stl.so"
         OLD_RPATH "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libcxxwrap_julia_stl.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/jlcxx" TYPE FILE FILES "/home/david/cuNumeric.jl/libcxxwrap-julia/include/jlcxx/stl.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/JlCxx/JlCxxConfigExports.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/JlCxx/JlCxxConfigExports.cmake"
         "/home/david/cuNumeric.jl/libcxxwrap-julia-build/CMakeFiles/Export/1875e327c0331cea4952ac810bab1d49/JlCxxConfigExports.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/JlCxx/JlCxxConfigExports-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/JlCxx/JlCxxConfigExports.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/JlCxx" TYPE FILE FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/CMakeFiles/Export/1875e327c0331cea4952ac810bab1d49/JlCxxConfigExports.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^()$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/JlCxx" TYPE FILE FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/CMakeFiles/Export/1875e327c0331cea4952ac810bab1d49/JlCxxConfigExports-noconfig.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/JlCxx" TYPE FILE FILES
    "/home/david/cuNumeric.jl/libcxxwrap-julia-build/JlCxxConfig.cmake"
    "/home/david/cuNumeric.jl/libcxxwrap-julia-build/JlCxxConfigVersion.cmake"
    "/home/david/cuNumeric.jl/libcxxwrap-julia/FindJulia.cmake"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/david/cuNumeric.jl/libcxxwrap-julia-build/examples/cmake_install.cmake")
  include("/home/david/cuNumeric.jl/libcxxwrap-julia-build/test/cmake_install.cmake")

endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/david/cuNumeric.jl/libcxxwrap-julia-build/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/david/cuNumeric.jl/libcxxwrap-julia-build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
