#!/bin/bash
# This script is temporary as a "hacky" patch until we solve the issue described:
# https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md

set -e 

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

exists=$CONDA_PREFIX/include/legion/legion_redop.inl 
new=$CUNUMERIC_ROOT_DIR/scripts/legion_redop_patch.inl

if [ -z "$CONDA_PREFIX" ]; then
  echo "Error: activate the conda env with cupynumeric."
  exit 1
fi

if [ -z "$CUNUMERIC_ROOT_DIR" ]; then
  echo "Error: CUNUMERIC_ROOT_DIR is not set."
  exit 1
fi

if [ -e "$exists" ]; then
  rm $exists 
fi 

cp $new $exists 
