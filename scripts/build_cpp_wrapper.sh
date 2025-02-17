set -e

# Check if exactly one argument is provided
if [[ $# -ne 4 ]]; then
    echo "Usage: $0 <root-dir> <build-dir> <cmake-prefix> <nthreads>"
    exit 1
fi

CUNUMERIC_ROOT_DIR=$1  # First argument
BUILD_DIR=$2
PREFIX_PATH=$3
NTHREADS=$4

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


CMAKE_PREFIX_PATH=$PREFIX_PATH cmake -S $CUNUMERIC_ROOT_DIR/wrapper -B $BUILD_DIR
cmake --build $BUILD_DIR  --parallel $NTHREADS --verbose