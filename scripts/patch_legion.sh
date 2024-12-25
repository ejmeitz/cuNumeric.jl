#!/bin/bash
exists=$CONDA_PREFIX/include/legion/legion_redop.inl 
new=./legion_redop_patch.inl

if [ -e "$exists" ]; then
  rm $exists 
fi 

cp $new $exists 
