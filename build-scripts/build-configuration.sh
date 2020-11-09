#!/usr/bin/env bash

# Build Options
if [ "$SINEWARE_DEVELOPMENT" = true ] # passed by the build-everything script.
then
  # if false, use the precompiled kernel without modules to speed up local builds. (probably won't boot on anything but QEMU)
  export COMPILE_KERNEL=false
else
  export COMPILE_KERNEL=true
fi
export SINEWARE_ARCH=x86_64 # Supported options: x86_64

# Names
export SINEWARE_NAME="Sineware"
export SINEWARE_VERSION="Development Milestone 1"
export SINEWARE_ID="sineware"
export SINEWARE_VERSION_ID="dev-m1-$(date '+%s')"

export SINEWARE_PRETTY_NAME="$SINEWARE_NAME $SINEWARE_VERSION ($SINEWARE_VERSION_ID)"

# Files
export SINEWARE_REPO_LINUX=https://github.com/Sineware/linux.git
export SINEWARE_REPO_GLIBC=https://github.com/Sineware/glibc.git
export SINEWARE_REPO_BUSYBOX=https://github.com/Sineware/busybox.git
export SINEWARE_REPO_BASH=https://github.com/Sineware/bash.git
export SINEWARE_REPO_NEOFETCH=https://github.com/Sineware/neofetch.git
export SINEWARE_REPO_NCURSES=https://github.com/Sineware/ncurses.git
export SINEWARE_REPO_HTOP=https://github.com/Sineware/htop.git
export SINEWARE_REPO_OPENSSH=https://github.com/Sineware/openssh.git
export SINEWARE_REPO_LIBFUSE=https://github.com/Sineware/libfuse.git
export SINEWARE_REPO_QEMU=https://github.com/Sineware/qemu.git
export SINEWARE_REPO_GLIB=https://github.com/Sineware/GLib.git

export SINEWARE_BIN_URL=https://sineware.ca/dist/components
export SINEWARE_BIN_TOOLCHAIN=sineware-toolchain-1.tar.bz2

# Toolchain
export SINEWARE_TRIPLET=x86_64-sineware-linux-gnu
export PATH="${PATH}:/build/toolchain/bin"

#export CC=${SINEWARE_TRIPLET}-gcc
#export CPP=${SINEWARE_TRIPLET}-g++
#export CXX=${SINEWARE_TRIPLET}-g++
##export LD=${SINEWARE_TRIPLET}-ld
#export CROSS_COMPILE=${SINEWARE_TRIPLET}-
#export CHOST=${SINEWARE_TRIPLET}


#export CPPFLAGS="-I${ROOTFS}/usr/"
#export CFLAGS="-I${ROOTFS}/usr/include"
#export LDFLAGS="-L${ROOTFS}/lib -L${ROOTFS}/lib64 -L${ROOTFS}/usr/lib -L${ROOTFS}/usr/lib64"

# Paths (do not modify)
#export ROOTFS=/build/rootfs
export ROOTFS=/build/toolchain/${SINEWARE_TRIPLET}/sysroot
export KERNEL_NAME=linux
export GLIBC_NAME=glibc
