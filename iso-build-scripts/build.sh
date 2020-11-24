#!/usr/bin/env bash
set -e
echo "Generating a Sineware ALPHA ISO on $(date)"
echo "Go get your noodles!"

export ROOTFS=/build/rootfs
#export LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1

echo "* Build Step: Preparing RootFS *"
mkdir -pv /build
mkdir -pv $ROOTFS
cd $ROOTFS
tar -xvf /build-scripts/files/sineware.tar.gz
#rm /build-scripts/files/sineware.tar.gz
ls -l

echo "* Build Step: Adding CD boot files *"
cp -r /build-scripts/files/boot/* $ROOTFS/boot/

echo "* Build Step: Generating ISO file *"
#grub-mkrescue -o /build-scripts/output/sineware.iso $ROOTFS

mkdir -pv $ROOTFS/boot/EFI/BOOT
cp -v /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi $ROOTFS/boot/EFI/BOOT/BOOTX64.EFI
cp -v /usr/lib/SYSLINUX.EFI/efi32/syslinux.efi $ROOTFS/boot/EFI/BOOT/BOOTIA32.EFI
cp -v /usr/lib/syslinux/modules/efi64/ldlinux.e64 $ROOTFS/boot/EFI/BOOT/ldlinux.e64
cp -v /usr/lib/syslinux/modules/efi32/ldlinux.e32 $ROOTFS/boot/EFI/BOOT/ldlinux.e32

echo "*Aura*  -> Stage 3 (Image)"
export IMAGE_FILE=/build/sineware.img

mkdir -p /mnt
guestfish -N $IMAGE_FILE=bootroot:fat:ext2:2G:128M:gpt<<_EOF_
exit
_EOF_
sync

LOOP_DEV=$(losetup -f)
echo "Loop Device: $LOOP_DEV"
losetup -f -P $IMAGE_FILE
losetup -l
echo "-"
ls -1 /dev/loop*

echo "Getting partition GUID"
# Get partition GUID
BOOT_GUID=$(blkid -s UUID -o value "$LOOP_DEV"p1)
ROOT_GUID=$(blkid -s UUID -o value "$LOOP_DEV"p2)
cat <<EOT >> /build/syslinux.cfg
DEFAULT linux
LABEL linux
    SAY Welcome to Sineware.
    KERNEL bzImage
EOT
# todo why isn't UUID working???
#echo "    APPEND root=UUID=$ROOT_GUID init=/init" >> /build/syslinux.cfg
echo "    APPEND root=/dev/sda2 init=/init quiet" >> /build/syslinux.cfg
cat /build/syslinux.cfg
echo "UUID=$ROOT_GUID / ext2 defaults 0 1" > $ROOTFS/etc/fstab
echo "UUID=$BOOT_GUID /boot vfat defaults 0 1" >> $ROOTFS/etc/fstab

echo "Mounting loopback devices"
mount "$LOOP_DEV"p2 /mnt
mkdir -p /mnt/boot
mount "$LOOP_DEV"p1 /mnt/boot

echo "*Aura*    -> Running rsync"
rsync -avxHAX $ROOTFS/ /mnt/

umount /mnt/boot
umount /mnt

# Set BIOS Boot flag and EFI partition
sgdisk --attributes=1:set:2 "$LOOP_DEV"
#sgdisk -t 1:ef00 "$LOOP_DEV"

losetup -d "$LOOP_DEV"

echo "*Aura*  -> Stage 4 (syslinux)"
#"sda" is the disk image in the guestfish environment
guestfish -a $IMAGE_FILE<<_EOF_
run
mount /dev/sda2 /
mount /dev/sda1 /boot
upload /usr/lib/SYSLINUX/gptmbr.bin /boot/mbr.bin
upload /build/syslinux.cfg /boot/syslinux.cfg
copy-file-to-device /boot/mbr.bin /dev/sda size:440
extlinux /boot
part-set-bootable /dev/sda 1 true
exit
_EOF_
sync
ls -l /build-scripts/output/
sleep 2
mv -v $IMAGE_FILE /build-scripts/output/sineware-hdd.img

echo "* Done! *"