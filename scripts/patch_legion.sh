#!/bin/bash
# This script is temporary as a "hacky" patch until we solve the issue described:
# https://github.com/ejmeitz/cuNumeric.jl/blob/main/scripts/README.md

set -e 

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <directory> <legate_loc>"
    exit 1
fi

CUNUMERIC_ROOT_DIR=$1  # First argument
LEGATE_LOC=$2 

# Check if the provided argument is a valid directory
if [[ ! -d "$CUNUMERIC_ROOT_DIR" ]]; then
    echo "Error: '$CUNUMERIC_ROOT_DIR' is not a valid directory."
    exit 1
fi

if [[ ! -d "$LEGATE_LOC" ]]; then
    echo "Error: '$LEGATE_LOC' is not a valid directory."
    exit 1
fi

exists=$LEGATE_LOC/include/legate/deps/legion/legion_redop.inl 
new=$CUNUMERIC_ROOT_DIR/scripts/legion_redop_patch.inl

if [ -z "$CUNUMERIC_ROOT_DIR" ]; then
  echo "Error: CUNUMERIC_ROOT_DIR is not set."
  exit 1
fi

if [ -e "$exists" ]; then
  rm $exists 
fi 

cp $new $exists 
