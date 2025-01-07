#!/bin/bash

# Copyright 2024 NVIDIA Corporation
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

# I don't think legate_root or cupynumeric_root are necessary here due to forcing CMAKE_PREFIX_PATH as the conda dir
# This may be useful if the user does custom legate / cupynumeric installs
# For our current purposes, I will leave this commented out 

# I have also forced absolute paths for CMAKE. This is needed if the user utilizes the Julia build system

# legate_root=`python -c 'import legate.install_info as i; from pathlib import Path; print(Path(i.libpath).parent.resolve())'`
# echo "Using Legate at $legate_root"
# cupynumeric_root=`python -c 'import cupynumeric.install_info as i; from pathlib import Path; print(Path(i.libpath).parent.resolve())'`
# echo "Using cuPyNumeric at $cupynumeric_root"

# CMAKE_PREFIX_PATH=$CONDA_PREFIX cmake -S . -B build -D legate_ROOT="$legate_root" -D cupynumeric_ROOT="$cupynumeric_root" -D CMAKE_BUILD_TYPE=Debug
# cmake --build build --parallel 8 --verbose

set -e 

if [ -z "$CUNUMERIC_JL_HOME" ]; then
  echo "Error: CUNUMERIC_JL_HOME is not set."
  exit 1
fi

# newer build
CMAKE_PREFIX_PATH=$CONDA_PREFIX cmake -S $CUNUMERIC_JL_HOME -B $CUNUMERIC_JL_HOME/build # -D CMAKE_BUILD_TYPE=Debug
cmake --build $CUNUMERIC_JL_HOME/build --parallel 8 --verbose
