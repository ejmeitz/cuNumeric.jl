set -e

# Check if exactly one argument is provided
if [[ $# -ne 6 ]]; then
    echo "Usage: $0 <cupynumeric-dir> <legate-dir> <hdf5-dir> <root-dir> <build-dir> <nthreads>"
    exit 1
fi
CUPYNUMERIC_ROOT_DIR=$1
LEGATE_ROOT_DIR=$2
HDF5_ROOT_DIR=$3
CUNUMERIC_ROOT_DIR=$4 # this is the repo root of cunumeric.jl
BUILD_DIR=$4 # /wrapper/build
NTHREADS=$6

# Check if the provided argument is a valid directory
if [[ ! -d "$CUNUMERIC_ROOT_DIR" ]]; then
    echo "Error: '$CUNUMERIC_ROOT_DIR' is not a valid directory."
    exit 1
fi

if [[ ! -d "$PREFIX_PATH" ]]; then
    echo "Error: '$PREFIX_PATH' is not a valid directory."
    exit 1
fi

if [[ ! -d "$BUILD_DIR" ]]; then
    echo "Error: '$BUILD_DIR' is not a valid directory."
    exit 1
fi

cmake -S $CUNUMERIC_ROOT_DIR/wrapper -B $BUILD_DIR \
    -DCUPYNUMERIC_PATH=$CUPYNUMERIC_ROOT_DIR \
    -DLEGATE_PATH=$LEGATE_ROOT_DIR \
    -DHDF5_PATH=$HDF5_ROOT_DIR
cmake --build $BUILD_DIR  --parallel $NTHREADS --verbose