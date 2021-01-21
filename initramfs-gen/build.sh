#!/usr/bin/env bash
set -e
echo "* Build Step: Creating the initramfs image... *"
echo "* On platform: $(uname -m)"

export ROOTFS=/build/rootfs
export BUSYBOX_PKG=busybox-1.32.1

export SINEWARE_BIN_URL=https://update.sineware.ca/dist/components

export SINEWARE_BIN_OPENWRT=openwrt-19.07.5-$(uname -m)-rootfs.tar.gz

mkdir -pv /build/rootfs

ls -l /artifacts

cd /build
mkdir -pv $ROOTFS/{usr/sbin,usr/bin,sbin,bin,dev,etc,mnt/root,mnt/live,proc,sys,lib/modules}

wget https://busybox.net/downloads/${BUSYBOX_PKG}.tar.bz2
tar xvf ${BUSYBOX_PKG}.tar.bz2

pushd .
cd $BUSYBOX_PKG
cp -v /build-scripts/files/busybox-config .config
# todo switch to musl (needed for dns too)
# or add glibc
LDFLAGS="--static" make -j$(nproc)
mv ./busybox $ROOTFS/bin
chroot $ROOTFS /bin/busybox --install -s
popd

cp /build-scripts/files/init $ROOTFS/

echo "* Adding Kernel Modules"
pushd .
cd $ROOTFS
tar xvf /artifacts/linux-modules.tar.gz
popd

cp /build-scripts/files/splash.bgra $ROOTFS/

cd $ROOTFS
find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > /artifacts/sineware-initramfs.cpio.gz
echo "Done!"