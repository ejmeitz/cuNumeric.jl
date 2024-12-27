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
tag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $tag


# https://github.com/JuliaInterop/libcxxwrap-julia/tree/v0.13.3?tab=readme-ov-file#preparing-the-install-location
# this command will download https://github.com/JuliaBinaryWrappers/libcxxwrap_julia_jll.jl and install it in JULIA_DEP_PATH
julia -e 'using Pkg; Pkg.develop(PackageSpec(name="libcxxwrap_julia_jll")); import libcxxwrap_julia_jll; libcxxwrap_julia_jll.dev_jll()'


# find julia dependency path
JULIA_DEP_PATH=$($JULIA -e 'println(DEPOT_PATH[1])')

# https://github.com/JuliaInterop/libcxxwrap-julia/tree/v0.13.3?tab=readme-ov-file#configuring-and-building
JULIA_CXXWRAP=$JULIA_DEP_PATH/dev/libcxxwrap_julia_jll/override

rm -rf $JULIA_CXXWRAP 
mkdir $JULIA_CXXWRAP

cmake -S $JULIA_CXXWRAP_SRC -B $JULIA_CXXWRAP -DJulia_EXECUTABLE=$JULIA_PATH 
cd $JULIA_CXXWRAP
make -j 16

