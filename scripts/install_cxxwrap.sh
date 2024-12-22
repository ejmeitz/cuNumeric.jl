#!/bin/bash

set -e

JULIA="julia"
JULIA_PATH=$(which $JULIA)
JULIA_CXXWRAP_SRC=$CUNUMERIC_JL_HOME/libcxxwrap-julia
JULIA_CXXWRAP=$CUNUMERIC_JL_HOME/libcxxwrap-julia-build

if [ -z "$CUNUMERIC_JL_HOME" ]; then
  echo "Error: CUNUMERIC_JL_HOME is not set."
  exit 1
fi


if [ -z "$JULIA_PATH" ]; then
  echo "Error: $JULIA is not installed or not in PATH."
  exit 1
fi

echo "Using $JULIA at: $JULIA_PATH"



mkdir $JULIA_CXXWRAP
cmake -S $JULIA_CXXWRAP_SRC -B $JULIA_CXXWRAP -DJulia_EXECUTABLE=$JULIA_PATH 
cd $JULIA_CXXWRAP
make -j 16

