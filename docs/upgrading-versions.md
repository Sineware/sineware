# Upgrading Package Versions

## Linux Kernel
There are two main spots where changes are needed when upgrading the kernel:
* kernel-gen (pull kernel tar.xz, update .config files)
* buildroot (update headers to match new kernel version)