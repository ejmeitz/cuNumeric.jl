# Install script for directory: /home/david/cuNumeric.jl/libcxxwrap-julia/examples

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
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libjlcxx_containers.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libjlcxx_containers.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libjlcxx_containers.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libjlcxx_containers.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libjlcxx_containers.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libjlcxx_containers.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libjlcxx_containers.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libjlcxx_containers.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexcept.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexcept.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexcept.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libexcept.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexcept.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexcept.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexcept.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libexcept.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libextended.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libextended.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libextended.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libextended.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libextended.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libextended.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libextended.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libextended.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libfunctions.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libfunctions.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libfunctions.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libfunctions.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libfunctions.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libfunctions.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libfunctions.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libfunctions.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libhello.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libhello.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libhello.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libhello.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libhello.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libhello.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libhello.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libhello.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbasic_types.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbasic_types.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbasic_types.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libbasic_types.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbasic_types.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbasic_types.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbasic_types.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libbasic_types.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libinheritance.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libinheritance.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libinheritance.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libinheritance.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libinheritance.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libinheritance.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libinheritance.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libinheritance.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libparametric.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libparametric.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libparametric.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libparametric.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libparametric.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libparametric.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libparametric.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libparametric.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpointer_modification.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpointer_modification.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpointer_modification.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libpointer_modification.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpointer_modification.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpointer_modification.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpointer_modification.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libpointer_modification.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libtypes.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libtypes.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libtypes.so"
         RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib/libtypes.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libtypes.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libtypes.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libtypes.so"
         OLD_RPATH "/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia:/home/david/cuNumeric.jl/libcxxwrap-julia-build/lib:"
         NEW_RPATH "/usr/local/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib:/home/david/.julia/juliaup/julia-1.11.2+0.x64.linux.gnu/lib/julia")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libtypes.so")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/david/cuNumeric.jl/libcxxwrap-julia-build/examples/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
