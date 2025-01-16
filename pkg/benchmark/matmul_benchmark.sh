#!/bin/bash

# if [[ $# -lt 1 ]]; then
#     echo "Usage: $0 [--gpus <num_gpus>] [--cpus <num_cpus>] [--mode <calculator_to_use>] [--N <matrix_size>] [--I <num_iters>]"
#     exit 1
# fi

# # Parse arguments
# FILENAME=$1
# shift

# GPUS=0
# CPUS=1

# while [[ $# -gt 0 ]]; do
#     case $1 in
#         --gpus)
#             GPUS=$2
#             shift 2
#             ;;
#         --cpus)
#             CPUS=$2
#             shift 2
#             ;;
#         *)
#             # Collect all other arguments as extra arguments
#             EXTRA_ARGS+=("$1")
#             shift
#             ;;
#     esac
# done

# # Validate the filename exists
# if [[ ! -f $FILENAME ]]; then
#     echo "Error: File $FILENAME does not exist."
#     exit 1
# fi

# # Inform user of the configuration
# if [[ $GPUS -lt 0 ]]; then
#     echo "GPUs invalid, using gpus = 0"
#     exit
# fi

# if [[ $CPUS -lt 0 ]]; then
#     echo "CPUs ivnalid, using cpus = 1"
#     exit
# fi

# eval run_benchmark.sh matmul.jl --cpus 10 --gpus 1 cuNumeric 1000 25