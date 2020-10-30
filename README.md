# Sineware Build System
![Sineware Logo](https://sineware.ca/img/v4-kenoi-el-logo-nobg.png)

This is the main repository of Sineware, the perfect host for containers and VMs!
(and a potentially a mobile platform too)

***SINEWARE IS UNDER HEAVY DEVELOPMENT! IT IS NOT READY TO USE YET.***

---
### Building Sineware
The `build-everything.sh` file will create a fresh rootfs tar.gz file (in ./build-scripts/output).
You need Docker on your system to run it! (Build testing will come eventually)

Both Linux and macOS (Docker Desktop) are officially supported as build hosts.

**You may find it useful to inspect the `build-configuration.sh` file in the build-scripts folder.**

`build-iso.sh` will create a simple read-only ISO (in ./iso-build-scripts/output) with GRUB. It will 
use the rootfs created by `build-everything.sh`, so run that first. This is useful for booting up in test
environments like QEMU.

---
### Testing with QEMU
Using the read-only ISO with QEMU is the easiest way to quickly boot Sineware from source.

First, create a disk image for the Data partition:

```bash
qemu-img create -f qcow2 sineware.qcow2 4G
```

Then, boot up the ISO file created by the `build-iso.sh` file:
```bash
qemu-system-x86_64 \
-m 1G \
-device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::8086-:8086 \
-cdrom iso-build-scripts/output/sineware.iso \
-hda sineware.qcow2
```

On Linux you can add the "-enable-kvm" option, and on macOS the "-accel hvf" option to speed up the VM with hardware acceleration.

On first boot, you'll want to run "mkfs.ext2 /dev/sda" to create a simple filesystem on the virtual disk. When you reboot, it will be mounted on /Data.

---
If you prefer to poke around inside the build container, you can build the build container (sineware-build) and use it directly:
```bash
docker run -t -i -v "$(pwd)"/build-scripts:/build-scripts --rm sineware-build bash
```
The sineware-build container currently is based on OpenSUSE Leap (yes, we are not self-hosting yet).
