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
wget https://distfiles.adelielinux.org/adelie/1.0/iso/rc2/adelie-rootfs-x86_64-1.0-rc2.txz

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
tar xvf /build/adelie-rootfs-x86_64-1.0-rc2.txz
popd

# Comes with crosstool-NG
#echo "* Build Step: glibc *"
#pushd .
#cd $GLIBC_NAME
#mkdir -pv build
#cd build
#../configure --prefix=/usr --host=x86_64-sineware-linux-gnu --build=x86_64-sineware-linux-gnu
#make -j$(nproc)
#make install DESTDIR=$ROOTFS
#popd
#ls -l $ROOTFS

echo "* Build Step: BusyBox *"
pushd .
cd busybox
make CROSS_COMPILE=${SINEWARE_TRIPLET}- defconfig
make CROSS_COMPILE=${SINEWARE_TRIPLET}- -j$(nproc)
cp -v busybox $ROOTFS/busybox
popd

pushd .
cd $ROOTFS
for util in $($ROOTFS/busybox --list-full); do
  ln -s /busybox $util
done
popd

echo "* Build Step: Adding files to rootfs *"
cp -v /build-scripts/files/init-files/init $ROOTFS/init
touch $ROOTFS/sineware.ini
cat <<EOT >> $ROOTFS/sineware.ini
hello=world
EOT
#cp -rv /build-scripts/files/etc/* $ROOTFS/etc/
#cp -rv /build-scripts/files/usr/* $ROOTFS/usr/
# Sineware System Files
#cp -rv /build-scripts/files/System/deno $ROOTFS/System/
#
#echo "* Building Additional System Components (Part 1) *"
#/build-scripts/components/library-patches/build.sh
#
#/build-scripts/components/libfuse/build.sh
#/build-scripts/components/glib/build.sh
#
#/build-scripts/components/bash/build.sh
#/build-scripts/components/neofetch/build.sh
#/build-scripts/components/openssh/build.sh
#/build-scripts/components/qemu/build.sh

# Sineware Components
#/build-scripts/files/System/CoreServices/build.sh
#/build-scripts/components/insert-name/build.sh
#
#echo "* Build Step: Components Part 1: Finishing touches... *"
#pushd .
# usr merge (todo bad idea?)
#mv $ROOTFS/bin/* $ROOTFS/usr/bin/
#rm -rf $ROOTFS/bin
#mv $ROOTFS/sbin/* $ROOTFS/usr/sbin/
#rm -rf $ROOTFS/sbin
#
# wtf (bash couldn't find /usr/lib?)
# maybe merge these 4 folders todo
#rsync -av $ROOTFS/usr/lib/ $ROOTFS/lib/
#rsync -av $ROOTFS/usr/lib64/* $ROOTFS/lib64

#rsync -av $ROOTFS/lib64/* $ROOTFS/lib

#cd $ROOTFS
#mkdir -pv bin sbin
#ln -s /usr/bin bin/
#ln -s /usr/sbin sbin/
#ln -s /lib lib64/
#popd

echo "* Build Step: Components Part 1: Cleaning up *"
# todo remove unnecessary files
#rm -rf $ROOTFS/usr/include # don't need development headers probably
#rm -rf $ROOTFS/usr/lib
#rm -rf $ROOTFS/usr/lib64

echo "* Build Step * Compiling Final Components"
#/build-scripts/components/htop/build.sh

echo "* Build Step: Kernel *"
if [ "$COMPILE_KERNEL" = true ]
then
  pushd . # Running pushd saves the current directory then popd brings us back there.
  cd $KERNEL_NAME
  echo "Build for ${SINEWARE_ARCH}"
  #make ${SINEWARE_ARCH}_defconfig
  #make menuconfig
  # todo check arch and use that kernel config
  cp -v /build-scripts/files/kernel/${SINEWARE_ARCH}/.config .
  make CROSS_COMPILE=${SINEWARE_TRIPLET}- -j$(nproc)
  cp -v arch/${SINEWARE_ARCH}/boot/bzImage $ROOTFS/boot/bzImage
  make CROSS_COMPILE=${SINEWARE_TRIPLET}- modules_install INSTALL_MOD_PATH=$ROOTFS
  popd
else
  echo "Development Build Only: Using prebuilt kernel image..."
  cp -v /build-scripts/files/kernel/${SINEWARE_ARCH}/bzImage $ROOTFS/boot/bzImage
fi


echo "* Build Step: Creating rootfs archive *"
cd $ROOTFS
echo "This ${SINEWARE_PRETTY_NAME} build was completed on $(date)" > ./sineware-release
tar -czvf /build-scripts/output/sineware.tar.gz .

echo "* Done! *"