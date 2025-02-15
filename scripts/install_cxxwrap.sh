#!/bin/bash
# Copyright 2025 Northwestern University, 
#                   Carnegie Mellon University University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author(s): David Krasowska <krasow@u.northwestern.edu>
#            Ethan Meitz <emeitz@andrew.cmu.edu>

set -e

# Check if exactly one argument is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

CUNUMERIC_ROOT_DIR=$1  # First argument

# Check if the provided argument is a valid directory
if [[ ! -d "$CUNUMERIC_ROOT_DIR" ]]; then
    echo "Error: '$CUNUMERIC_ROOT_DIR' is not a valid directory."
    exit 1
fi

JULIA='julia'
JULIA_PATH=$(which $JULIA)

if [ -z "$JULIA_PATH" ]; then
  echo "Error: $JULIA is not installed or not in PATH."
  exit 1
fi

echo "Using $JULIA at: $JULIA_PATH"

JULIA_CXXWRAP_SRC=$CUNUMERIC_ROOT_DIR/libcxxwrap-julia

cd $JULIA_CXXWRAP_SRC

# grab latest release of libcxxwrap-julia
# in theory the latest libcxxwrap could be incompatible with latest CxxWrap
  # if CxxWrap has not tagged a new version
tag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $tag

# find julia dependency path
JULIA_DEP_PATH=$($JULIA -e 'println(DEPOT_PATH[1])')

# https://github.com/JuliaInterop/libcxxwrap-julia/tree/v0.13.3?tab=readme-ov-file#configuring-and-building
JULIA_CXXWRAP_DEV=$JULIA_DEP_PATH/dev/libcxxwrap_julia_jll
JULIA_CXXWRAP=$JULIA_CXXWRAP_DEV/override

# Clean up whatever env is there right now and
# build default version of CxxWrap / libcxxwrap_julia
#* THIS COULD BREAK SOME USERS CODE IF THEY ALREADY OVERRIDE THIS PKG
cd $CUNUMERIC_ROOT_DIR/pkg
rm -rf "Manifest.toml"
rm -rf $JULIA_CXXWRAP_DEV
julia -e 'using Pkg; Pkg.activate("."); Pkg.resolve(); Pkg.precompile(["CxxWrap"])'

# https://github.com/JuliaInterop/libcxxwrap-julia/tree/v0.13.3?tab=readme-ov-file#preparing-the-install-location
# this command will download https://github.com/JuliaBinaryWrappers/libcxxwrap_julia_jll.jl and install it in JULIA_DEP_PATH
julia -e 'using Pkg; Pkg.activate("."); Pkg.develop(PackageSpec(name="libcxxwrap_julia_jll")); import libcxxwrap_julia_jll; libcxxwrap_julia_jll.dev_jll()'


# JULIA_CXXWRAP_OVERRIDE=$JULIA_CXXWRAP/override/
# Delete the default JLL installation of cxxwrap_julia
rm -rf $JULIA_CXXWRAP 
mkdir $JULIA_CXXWRAP

cmake -S $JULIA_CXXWRAP_SRC -B $JULIA_CXXWRAP -DJulia_EXECUTABLE=$JULIA_PATH -DCMAKE_BUILD_TYPE=Release
cd $JULIA_CXXWRAP
make -j 16