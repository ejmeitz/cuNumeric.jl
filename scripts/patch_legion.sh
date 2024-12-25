#!/bin/bash


set -e 

exists=$CONDA_PREFIX/include/legion/legion_redop.inl 
new=./legion_redop_patch.inl



if [ -z "$CONDA_PREFIX" ]; then
  echo "Error: activate the conda env with cupynumeric."
  exit 1
fi



if [ -e "$exists" ]; then
  rm $exists 
fi 

cp $new $exists 
