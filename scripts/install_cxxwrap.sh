#!/bin/bash

set -e

JULIA='julia'

if [ -z "$CUNUMERIC_JL_HOME" ]; then
  echo "Error: CUNUMERIC_JL_HOME is not set."
  exit 1
fi


if [ -z "$JULIA_PATH" ]; then
  echo "Error: $JULIA is not installed or not in PATH."
  exit 1
fi


echo "Using $JULIA at: $JULIA_PATH"


JULIA_CXXWRAP_SRC=$CUNUMERIC_JL_HOME/libcxxwrap-julia

cd $JULIA_CXXWRAP_SRC

# grab latest release of libcxxwrap-julia
# in theory the latest libcxxwrap could be incompatible with latest CxxWrap
  # if CxxWrap has not tagged a new version
tag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $tag

# find julia dependency path
JULIA_DEP_PATH=$($JULIA -e 'println(DEPOT_PATH[1])')

# https://github.com/JuliaInterop/libcxxwrap-julia/tree/v0.13.3?tab=readme-ov-file#configuring-and-building
JULIA_CXXWRAP=$JULIA_DEP_PATH/dev/libcxxwrap_julia_jll/override

# Clean up whatever env is there right now and
# build default version of CxxWrap / libcxxwrap_julia
#* THIS COULD BREAK SOME USERS CODE IF THEY ALREADY OVERRIDE THIS PKG
cd $CUNUMERIC_JL_HOME/pkg
rm -rf "Manifest.toml"
rm -rf $JULIA_CXXWRAP
julia -e 'using Pkg; Pkg.activate("."); Pkg.resolve(); Pkg.precompile(["CxxWrap"])'

# https://github.com/JuliaInterop/libcxxwrap-julia/tree/v0.13.3?tab=readme-ov-file#preparing-the-install-location
# this command will download https://github.com/JuliaBinaryWrappers/libcxxwrap_julia_jll.jl and install it in JULIA_DEP_PATH
julia -e 'using Pkg; Pkg.activate("."); Pkg.develop(PackageSpec(name="libcxxwrap_julia_jll")); import libcxxwrap_julia_jll; libcxxwrap_julia_jll.dev_jll()'


# JULIA_CXXWRAP_OVERRIDE=$JULIA_CXXWRAP/override/
# Delete the default JLL installation of cxxwrap_julia
rm -rf $JULIA_CXXWRAP 
mkdir $JULIA_CXXWRAP

cmake -S $JULIA_CXXWRAP_SRC -B $JULIA_CXXWRAP -DJulia_EXECUTABLE=$JULIA_PATH 
cd $JULIA_CXXWRAP
make -j 16

