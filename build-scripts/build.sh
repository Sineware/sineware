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
echo "* Starting Sineware ALPHA build on $(date) *"
echo "Go get your noodles, this may take a while!"

source /build-scripts/build-configuration.sh

echo "* Build Step: Getting Ready *"

mkdir -pv /build/rootfs && cd /build

echo "* Build Step: Gathering Components *"
git clone $SINEWARE_REPO_LINUX --depth 1
git clone $SINEWARE_REPO_GLIBC --depth 1
git clone $SINEWARE_REPO_BUSYBOX --depth 1

echo "* Step 3: Preparing Directories *"
# These are temporary and will be removed at the end of the build process.
mkdir -pv $ROOTFS/bin
mkdir -pv $ROOTFS/sbin

mkdir -pv $ROOTFS/usr/bin
mkdir -pv $ROOTFS/usr/sbin

mkdir -pv $ROOTFS/proc
mkdir -pv $ROOTFS/sys
mkdir -pv $ROOTFS/dev
mkdir -pv $ROOTFS/etc
mkdir -pv $ROOTFS/tmp
mkdir -pv $ROOTFS/boot

# These are temporary and will be removed at the end of the build process.
#mkdir -pv $ROOTFS/lib
mkdir -pv $ROOTFS/lib64

mkdir -pv $ROOTFS/System
mkdir -pv $ROOTFS/Data

ls -l
ls -l $ROOTFS

echo "* Build Step: glibc *"
pushd .
cd $GLIBC_NAME
mkdir -pv build
cd build
../configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$ROOTFS
popd
ls -l $ROOTFS

echo "* Build Step: Kernel *"
if [ "$COMPILE_KERNEL" = true ]
then
  pushd . # Running pushd saves the current directory then popd brings us back there.
  cd $KERNEL_NAME
  make x86_64_defconfig # todo make a kernel .config
  make -j$(nproc)
  cp arch/x86_64/boot/bzImage $ROOTFS/boot/bzImage
  make modules_install INSTALL_MOD_PATH=$ROOTFS
  popd
else
  echo "Development Build Only: Using prebuilt kernel image..."
  cp /build-scripts/files/bzImage $ROOTFS/boot/bzImage
fi

echo "* Build Step: BusyBox *"
pushd .
cd busybox
make defconfig
make -j$(nproc)
cp busybox $ROOTFS/System/busybox
popd

pushd .
cd $ROOTFS
for util in $($ROOTFS/System/busybox --list-full); do
  ln -s /System/busybox $util
done
popd

echo "* Building Additional System Components *"
/build-scripts/components/bash/build.sh
/build-scripts/components/neofetch/build.sh
/build-scripts/components/ncurses/build.sh
/build-scripts/components/htop/build.sh
/build-scripts/components/openssh/build.sh
/build-scripts/components/library-patches/build.sh

/build-scripts/files/System/CoreServices/build.sh

echo "* Build Step: Adding files to rootfs *"
cp /build-scripts/files/init-files/init $ROOTFS/init
cp -r /build-scripts/files/etc/* $ROOTFS/etc/
cp -r /build-scripts/files/usr/* $ROOTFS/usr/
# Sineware System Files
cp -r /build-scripts/files/System/deno $ROOTFS/System/

# usr merge (todo bad idea?)
mv $ROOTFS/bin/* $ROOTFS/usr/bin/
rm -rf $ROOTFS/bin
mv $ROOTFS/sbin/* $ROOTFS/usr/sbin/
rm -rf $ROOTFS/sbin

echo "* Build Step: Cleaning up *"
#rm -rf $ROOTFS/var

echo "* Build Step: Creating rootfs archive *"
cd $ROOTFS
echo "This Sineware $SINEWARE_VERSION_NAME build was compiled on $(date)" > System/sineware-release
tar -czvf /build-scripts/output/sineware.tar.gz .

echo "* Done! *"