#!/bin/bash

# This script is used to install and place everything for development

# Download to iss output directory
echo "Downloading QEMU ($QEMU_RELEASE) to $ISS_DIR..."

# Remove current QEMU version
rm -rf $ISS_DIR/*

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