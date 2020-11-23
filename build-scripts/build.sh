#!/usr/bin/env bash
#  Copyright (C) 2020 Seshan Ravikumar
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -e # Crash when a command fails


echo "* Starting $SINEWARE_PRETTY_NAME build on $(date) *"
echo "Go get your noodles, this may take a while!"

source /build-scripts/build-configuration.sh

echo "* Build Step: Getting Ready *"

mkdir -pv /tools

mkdir -pv /build/rootfs && cd /build

echo "* Build Step: Gathering Initial Components *"

cd /build

git clone $SINEWARE_REPO_BUSYBOX --depth 1
wget https://distfiles.adelielinux.org/adelie/1.0/iso/rc2/adelie-rootfs-mini-${SINEWARE_ARCH}-1.0-rc2.txz

# ~~ Build the Toolchain, environment variables were set in build-configuration
/build-scripts/toolchain/build.sh

echo "* Build Step: Preparing Directories *"
mkdir -pv $ROOTFS/root_a $ROOTFS/root_b
mkdir -pv $ROOTFS/data

mkdir -pv $ROOTFS/bin
mkdir -pv $ROOTFS/sbin
mkdir -pv $ROOTFS/usr/bin
mkdir -pv $ROOTFS/usr/sbin

mkdir -pv $ROOTFS/boot

mkdir -pv $ROOTFS/dev mkdir -pv $ROOTFS/proc mkdir -pv $ROOTFS/sys

ls -l
ls -l $ROOTFS

echo "* Build Step: Extracting Adelie RootFS *"
pushd .
cd $ROOTFS/root_a
tar xvf /build/adelie-rootfs-mini-${SINEWARE_ARCH}-1.0-rc2.txz
popd

#echo "* Build Step: BusyBox *"
#pushd .
#cd busybox
#make CROSS_COMPILE=${SINEWARE_TRIPLET}- defconfig
#make CROSS_COMPILE=${SINEWARE_TRIPLET}- -j$(nproc)
#cp -v busybox $ROOTFS/busybox
#popd
#
#pushd .
#cd $ROOTFS
#for util in $($ROOTFS/busybox --list-full); do
#  ln -s /busybox $util
#done
#popd

echo "* Build Step: Adding files to rootfs *"
#cp -v /build-scripts/files/init-files/init $ROOTFS/init

pushd .
cd /build-scripts/components/sineware-init
make CXX=${SINEWARE_ARCH}-sineware-linux-gnu-g++
make install DESTDIR=${ROOTFS}

touch $ROOTFS/sineware.ini
cat <<EOT >> $ROOTFS/sineware.ini
[sineware]
version=${SINEWARE_VERSION_ID}
init=bash

[bash]
exec=/bin/bash
EOT
#cp -rv /build-scripts/files/etc/* $ROOTFS/etc/

# Sineware Components
#/build-scripts/components/insert-name/build.sh

echo "* Build Step: Components Part 1: Cleaning up *"
# todo remove unnecessary files
#rm -rf $ROOTFS/usr/include # don't need development headers probably
#rm -rf $ROOTFS/usr/lib
#rm -rf $ROOTFS/usr/lib64

echo "* Build Step * Compiling Final Components"
#/build-scripts/components/htop/build.sh


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ todo eventually this should be separate for update purposes
echo "* Build Step * Setting up Adelie (in chroot)"
pushd .
cd $ROOTFS/root_a
#mount -t proc /proc proc/
#mount --rbind /sys sys/
#mount --rbind /dev dev/

cp /etc/resolv.conf etc/resolv.conf

chroot $ROOTFS/root_a /sbin/apk update
chroot $ROOTFS/root_a /sbin/apk add bash wget
chroot $ROOTFS/root_a /bin/sh -c "cd /sbin && wget https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch && chmod +x neofetch"
popd
echo "* Build Step: Kernel *"
# Sineware Ubuntu HWE Compatible Kernel
# todo this should be part of image generation not rootfs
pushd .
mkdir -pv /build/kernel && cd /build/kernel

apt download linux-image-${SINEWARE_UBUNTU_KERNEL_VERSION}
apt download linux-modules-${SINEWARE_UBUNTU_KERNEL_VERSION}

# kernel image
dpkg-deb -xv linux-image-*.deb .
cp -v boot/vmlinuz* $ROOTFS/boot/bzImage

# kernel modules
dpkg-deb -xv linux-modules-*.deb .
cp -v boot/System.map* $ROOTFS/boot/
cp -v boot/config* $ROOTFS/boot/

cp -rv lib/* $ROOTFS/lib/

popd

echo "* Build Step: Creating rootfs archive *"
cd $ROOTFS
echo "This ${SINEWARE_PRETTY_NAME} build was completed on $(date)" > ./sineware-release
tar -czvf /build-scripts/output/sineware.tar.gz .

echo "* Done! *"