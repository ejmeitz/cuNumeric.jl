#!/bin/bash
# This script is temporary as a "hacky" patch until we solve the issue described:
# https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md

set -e 

exists=$CONDA_PREFIX/include/legion/legion_redop.inl 
new=$CUNUMERIC_JL_HOME/scripts/legion_redop_patch.inl

if [ -z "$CONDA_PREFIX" ]; then
  echo "Error: activate the conda env with cupynumeric."
  exit 1
fi

if [ -z "$CUNUMERIC_JL_HOME" ]; then
  echo "Error: CUNUMERIC_JL_HOME is not set."
  exit 1
fi

if [ -e "$exists" ]; then
  rm $exists 
fi 

cp $new $exists 
