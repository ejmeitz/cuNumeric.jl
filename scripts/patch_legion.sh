#!/bin/bash
exists=$cupynumeric_RT/include/legion/legion_redop.inl
new=legion_redop_patch.inl

rm $exists
cp $new $exists 
