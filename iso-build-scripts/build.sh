#!/usr/bin/env bash
echo "Generating a Sineware ALPHA ISO on $(date)"
echo "Go get your noodles!"

export ROOTFS=/build/rootfs

echo "* Build Step: Preparing RootFS *"
mkdir -pv $ROOTFS
cd $ROOTFS
tar -xvf /build-scripts/files/sineware.tar.gz
rm /build-scripts/files/sineware.tar.gz
ls -l

echo "* Build Step: Adding CD boot files *"
cp -r /build-scripts/files/boot/* $ROOTFS/boot/

echo "* Build Step: Generating ISO file *"
grub2-mkrescue -o /build-scripts/output/sineware.iso $ROOTFS



echo "* Done! *"