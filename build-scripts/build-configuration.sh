#!/usr/bin/env bash

# Files
export SINEWARE_REPO_LINUX=https://github.com/Sineware/linux.git
export SINEWARE_REPO_GLIBC=https://github.com/Sineware/glibc.git
export SINEWARE_REPO_BUSYBOX=https://github.com/Sineware/busybox.git
export SINEWARE_REPO_BASH=https://github.com/Sineware/bash.git
export SINEWARE_REPO_NEOFETCH=https://github.com/Sineware/neofetch.git
export SINEWARE_REPO_NCURSES=https://github.com/Sineware/ncurses.git
export SINEWARE_REPO_HTOP=https://github.com/Sineware/htop.git
export SINEWARE_REPO_OPENSSH=https://github.com/Sineware/openssh.git

# Build Options
export COMPILE_KERNEL=true # if false, a bzImage should be in build-scripts/files (NOTE no kernel modules are copied)
export SINEWARE_ARCH=x86_64

# Names
export SINEWARE_NAME="Sineware"
export SINEWARE_VERSION="Development Milestone 1"
export SINEWARE_ID="sineware"
export SINEWARE_VERSION_ID="dev-m1"

export SINEWARE_PRETTY_NAME="$SINEWARE_NAME $SINEWARE_VERSION ($SINEWARE_VERSION_ID)"


# Paths (do not modify?)
export ROOTFS=/build/rootfs
export KERNEL_NAME=linux
export GLIBC_NAME=glibc