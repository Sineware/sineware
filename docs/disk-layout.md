# Sineware ProLinux Server: Disk Layouts
The following document outlines the layout and contents of 
various ProLinux Server (PLS) disks.

## Live CD
The PLS install/live CD consists of GRUB with a single ISO9660 partition.
The root filesystem contains:
- **/boot** - The Kernel, InitRAMFS and GRUB config files.
- **/squashfs.img** - The PLS Live SquashFS Image

GRUB is responsible for loading the kernel and InitRAMFS from the ISO9660 partition.

The SquashFS image is mounted by the InitRAMFS (See the next section).

## InitRAMFS (Initial RAM Filesystem)
The InitRAMFS' goal is to provide a temporary userspace to find and mount the real 
system root. In practice this means loading in the kernel modules for the local disk, 
or the network card.

The filesystem itself is a cpio.gz archive, which is extracted by the kernel into a 
tmpfs. The InitRAMFS contains a minimal busybox-based filesystem layout.

Folders of note include:
- **/mnt/root** - the location of the Sineware PLS boot files. On a Live CD, this is the ISO9660 FS. On a standalone server,
this is a partiton on a local disk, and on a netboot server this is a network mount.
- **/mnt/live** - the final mountpoint of the real root filesystem.
    - **/mnt/live/rom** - the location of the mounted SquashFS image.
    - **/mnt/live/overlay** - a tmpfs mounted for the read/write OverlayFS.
        - **/mnt/overlay/fs** and **/mnt/overlay/work** - two folders required for an OverlayFS.
        
After /mnt/live/rom and /mnt/live/overlay are setup and mounted, the two are merged using OverlayFS on top of /mnt/live to 
provide a single read/write rootfs for the system to boot into. Recall that a SquashFS image is read-only, so overlay mounting it 
with a tmpfs allows the system to write temporary runtime configuration files (such as DHCP information).

The InitramFS then cleans up and boots into /mnt/live, launching the init system (handing over PID 1 using switch_root), and 
the system now begins to boot Sineware ProLinux.

## Standalone Server

## Netboot Server
