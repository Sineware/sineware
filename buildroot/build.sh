#!/usr/bin/env bash
set -e
echo "* Building the RootFS with buildroot... *"
source ../buildmeta/buildconfig.sh
cd buildroot

echo "  * Reading configuration files..."
make clean
# Todo: Select defconfig from buildmeta config.
make BR2_EXTERNAL=../br2external BR2_DEFCONFIG=../br2external/configs/prolinuxserver_defconfig defconfig

echo "  * Starting Build! 🚀"
make all

echo "  * Copying and compressing the tar..."
cp -v output/images/rootfs.tar ../../artifacts/rootfs.tar
gzip ../../artifacts/rootfs.tar
mv -v ../../artifacts/rootfs.tar.gz ../../artifacts/sineware-buildroot.tar.gz