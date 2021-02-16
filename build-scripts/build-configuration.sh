#!/usr/bin/env bash
# Local Build Configuration

export SINEWARE_ARCH=$(uname -m)

# Build Options
if [ "$SINEWARE_DEVELOPMENT" = true ] # passed by the build-everything script.
then
  # if false, use the precompiled kernel without modules to speed up local builds. (probably won't boot on anything but QEMU)
  export COMPILE_KERNEL=false
else
  export COMPILE_KERNEL=true
fi

export SINEWARE_SUPPORTED_ARCH=("x86_64" "aarch64")
if [[ ! " ${SINEWARE_SUPPORTED_ARCH[@]} " =~ " ${SINEWARE_ARCH} " ]]; then
  echo "ERROR: Invalid Build Architecture (${SINEWARE_ARCH})! "
  exit 1
fi

# Files
export SINEWARE_BIN_URL=https://update.sineware.ca/dist/components
export SINEWARE_BIN_TOOLCHAIN=${SINEWARE_ARCH}-sineware-toolchain-1.tar.bz2

export SINEWARE_BIN_OPENWRT=openwrt-19.07.5-${SINEWARE_ARCH}-rootfs.tar.gz

# Toolchain
export SINEWARE_TRIPLET=${SINEWARE_ARCH}-sineware-linux-gnu
export PATH="${PATH}:/build/toolchain/bin"

# Paths (do not modify)
export ROOTFS=/build/rootfs
#export ROOTFS=/build/toolchain/${SINEWARE_TRIPLET}/sysroot
export KERNEL_NAME=linux
export GLIBC_NAME=glibc
