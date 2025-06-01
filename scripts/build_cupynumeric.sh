set -e

# Check if exactly one argument is provided
if [[ $# -ne 5 ]]; then
    echo "Usage: $0  <root-dir> <legate-dir> <build-dir> <version> <nthreads>"
    exit 1
fi
CUNUMERIC_ROOT_DIR=$1
LEGATE_ROOT_DIR=$2
BUILD_DIR=$3
VERSION=$4
NTHREADS=$5

# Check if the provided argument is a valid directory
if [[ ! -d "$CUNUMERIC_ROOT_DIR" ]]; then
    echo "Error: '$CUNUMERIC_ROOT_DIR' is not a valid directory."
    exit 1
fi

if [[ ! -d "$BUILD_DIR" ]]; then
    echo "Error: '$BUILD_DIR' is not a valid directory."
    exit 1
fi

TAG="v$VERSION"
REPO_URL="https://github.com/nv-legate/cupynumeric"
TAG_URL="$REPO_URL/releases/tag/$TAG"
CLONE_DIR="cupynumeric-$VERSION"

echo "Checking if tag $TAG exists on GitHub..."

if curl --silent --head --fail "$TAG_URL" > /dev/null; then
    echo "Tag $TAG exists. Cloning..."
else
    echo "Error: Tag $TAG does not exist at $TAG_URL"
    exit 1
fi

if [ -d "$CLONE_DIR" ]; then
    echo "Directory '$CLONE_DIR' already exists. Skipping clone."
else
    git clone --branch "$TAG" --depth 1 "$REPO_URL.git" "$CLONE_DIR"
    echo "Cloned cuNumeric $VERSION into $CLONE_DIR"
fi

echo $LEGATE_ROOT_DIR
 
cmake -S $CUNUMERIC_ROOT_DIR/deps/$CLONE_DIR -B $BUILD_DIR \
    -D legate_ROOT=$LEGATE_ROOT_DIR
cmake --build $BUILD_DIR  --parallel $NTHREADS --verbose

# $CUNUMERIC_ROOT_DIR/deps/$CLONE_DIR/install.py --cuda --hdf5 --spy --clean -j $NTHREADS