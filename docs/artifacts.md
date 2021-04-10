# What produces what?

* sineware-buildroot.tar.gz -> "make build_buildroot" Basic rootfs from buildroot, used to generate sineware.tar.gz
* sineware.tar.gz -> "make system_rootfs" (basic rootfs) from "build-scripts"
* sineware.squashfs.img and sineware.iso -> "make sineware_img" (Live ISO/installer) from "iso-build-scripts"
* sineware-initramfs.cpio.gz -> "make initramfs" (initramfs) from "initramfs-gen"
* bzImage and linux-modules.tar.gz -> "make kernel" (Linux image and modules) from "kernel-gen"