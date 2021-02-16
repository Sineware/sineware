# Sineware Build System for ProLinux
![Sineware Logo](https://update.sineware.ca/dist/prolinux-logo.png)

> Warning: this documentation is pretty outdated at the moment!


https://sineware.ca/ 

This is the main repository of Sineware ProLinux (formerly Sineware EL Server), the perfect host for containers and VMs!
(and a potentially a mobile platform too)

***ProLinux IS UNDER HEAVY DEVELOPMENT! IT IS NOT READY TO USE YET.***

---
### Building Sineware ProLinux
The `make all` command will create a fresh rootfs tar.gz file (in ./artifacts/sineware.tar.gz), and a live ISO (in ./artifacts/sineware.iso).
You need Docker on your system to run it! (Build testing will come eventually)

Both Linux and macOS (Docker Desktop) are officially supported as build hosts.

See the docs/ directory for some documentation.

---
### Testing with QEMU
Using the testing IMG file with QEMU is the easiest way to quickly boot Sineware built from source.

```bash
qemu-system-x86_64 \
-m 1G \
-device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::8086-:8086 \
-hda artifacts/sineware-hdd.img 
```

On Linux you can add the "-enable-kvm" option, and on macOS the "-accel hvf" option to speed up the VM with hardware acceleration.

---
If you prefer to poke around inside the build container, you can build the build container (sineware-build) and use it directly:
```bash
docker run -t -i -v "$(pwd)"/build-scripts:/build-scripts --rm sineware-build bash
```
The sineware-build container currently is based on Ubuntu (yes, we are not self-hosting yet).
