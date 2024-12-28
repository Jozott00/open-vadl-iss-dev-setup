#!/bin/bash

# This script is used to install and place everything for development

# Check if the script is being run from a devcontainer
# by checking if the Dockerfile exists (in workspace) and $ISS_DIR is set and $REMOTE_CONTAINERS is true
if [ -n "$ISS_DIR" ] && [ "$REMOTE_CONTAINERS" = "true" ]; then
  echo "Downloading QEMU ($QEMU_RELEASE) to $ISS_DIR..."
else
  echo "This script is intended to be run in the devcontainer."
  exit 1
fi

# Remove current QEMU version
# rm -rf $ISS_DIR/*

mkdir -p $ISS_DIR
cd $ISS_DIR
curl -L $QEMU_RELEASE | tar -xz --strip-components=1
echo "done."

# Clone VADL
echo "Cloning VADL to $VADL_DIR..."
mkdir -p $VADL_DIR
cd $VADL_DIR
git clone $VADL_REPO .
git submodule init
git submodule update

cd $OPEN_VADL_DIR
git checkout origin/master