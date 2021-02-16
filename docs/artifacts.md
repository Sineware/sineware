# What produces what?

* sineware.tar.gz -> "make system_rootfs" (basic rootfs) from "build-scripts"
* sineware.iso -> "make sineware_img" (Live ISO/installer) from "iso-build-scripts"
* sineware-initramfs.cpio.gz -> "make initramfs" (initramfs) from "initramfs-gen"
* bzImage and linux-modules.tar.gz -> "make kernel" (Linux image and modules) from "kernel-gen"