#!/bin/bash

cd $(dirname $0)/..

set -e

mkdir -p build
pushd build > /dev/null

echo "[*] preparing source..."
git clone https://github.com/libssh2/libssh2 libssh2 || true

pushd libssh2 > /dev/null
SOURCE_DIR=$(pwd)

git clean -fdx > /dev/null
git reset --hard > /dev/null
git checkout master > /dev/null
git pull > /dev/null

MAJOR=0
MINOR=0
PATCH=0
for TAG in $(git tag | grep -E '^libssh2-[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1); do
    TAG=${TAG#libssh2-}
    CURRENT_MAJOR=${TAG%%.*}
    TAG=${TAG#*.}
    CURRENT_MINOR=${TAG%%.*}
    TAG=${TAG#*.}
    CURRENT_PATCH=${TAG%%.*}
    if [ $CURRENT_MAJOR -gt $MAJOR ]; then
        MAJOR=$CURRENT_MAJOR
        MINOR=$CURRENT_MINOR
        PATCH=$CURRENT_PATCH
    elif [ $CURRENT_MAJOR -eq $MAJOR ] && [ $CURRENT_MINOR -gt $MINOR ]; then
        MINOR=$CURRENT_MINOR
        PATCH=$CURRENT_PATCH
    elif [ $CURRENT_MAJOR -eq $MAJOR ] && [ $CURRENT_MINOR -eq $MINOR ] && [ $CURRENT_PATCH -gt $PATCH ]; then
        PATCH=$CURRENT_PATCH
    fi
done
echo "[*] latest version: $MAJOR.$MINOR.$PATCH"
git checkout libssh2-$MAJOR.$MINOR.$PATCH > /dev/null
TARGET_TAG=$MAJOR.$MINOR.$PATCH

popd > /dev/null # openssh
popd > /dev/null # build

git pull --tags > /dev/null
if [ $(git tag | grep -E "^$TARGET_TAG$" | wc -l) -gt 0 ]; then
    echo "[*] tag $TARGET_TAG already exists"
    exit 0
fi

echo "[*] generating source..."

PACKAGE_NAME="CSSH2"

rm -rf Sources
mkdir -p Sources/$PACKAGE_NAME

TARGET_INCLUDE_DIR=$(pwd)/Sources/$PACKAGE_NAME/include
TARGET_SOURCE_DIR=$(pwd)/Sources/$PACKAGE_NAME

echo "[*] copying include..."
pushd $SOURCE_DIR/include > /dev/null
for FILE in $(find . -type f); do
    if [ ${FILE:0:2} == "./" ]; then
        FILE=${FILE:2}
    fi
    TARGET_PATH=$TARGET_INCLUDE_DIR/$FILE
    mkdir -p $(dirname $TARGET_PATH)
    cp $FILE $TARGET_PATH
done
popd > /dev/null # include

echo "[*] copying src..."
pushd $SOURCE_DIR/src > /dev/null
for FILE in $(find . -type f); do
    if [ ${FILE##*.} != "c" ] && [ ${FILE##*.} != "h" ]; then
        continue
    fi
    if [ ${FILE:0:2} == "./" ]; then
        FILE=${FILE:2}
    fi
    TARGET_PATH=$TARGET_SOURCE_DIR/$FILE
    mkdir -p $(dirname $TARGET_PATH)
    cp $FILE $TARGET_PATH
done
popd > /dev/null # src


echo $TARGET_TAG > tag.txt
echo "[*] done $(basename $0) : $TARGET_TAG"
