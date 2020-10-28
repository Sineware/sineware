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
export COMPILE_KERNEL=false # if false, a bzImage should be in build-scripts/files (NOTE no kernel modules are copied)
export SINEWARE_VERSION_NAME=DEVELOPMENT

# Paths (do not modify?)
export ROOTFS=/build/rootfs
export KERNEL_NAME=linux
export GLIBC_NAME=glibc