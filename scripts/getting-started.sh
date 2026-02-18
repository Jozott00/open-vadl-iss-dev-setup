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
rm -rf $ISS_DIR/*

mkdir -p $ISS_DIR
cd $ISS_DIR
curl -L $QEMU_RELEASE | tar -xz --strip-components=1
echo "done."

# Clone VADL
echo "Cloning OpenVADL to $OPEN_VADL_DIR..."
mkdir -p $OPEN_VADL_DIR
cd $OPEN_VADL_DIR
git clone $OPEN_VADL_GIT_REPO .

run-cosim-install