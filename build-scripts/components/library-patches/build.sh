#!/usr/bin/env bash
set -e
echo "* Build Step: Libraries & Patches *"
pushd .

# libffi
cd /build
echo "*    -> libffi"
wget https://github.com/libffi/libffi/releases/download/v3.3/libffi-3.3.tar.gz
tar xvf libffi-3.3.tar.gz
cd libffi-3.3
./configure --prefix /usr --host=x86_64-sineware-linux-gnu --build=x86_64-sineware-linux-gnu
make -j$(nproc)
make install DESTDIR=$ROOTFS
cd $ROOTFS/usr/lib/

# zlib
cd /build
wget https://zlib.net/zlib-1.2.11.tar.gz
tar xvf zlib-1.2.11.tar.gz
cd zlib-1.2.11
CC=${SINEWARE_TRIPLET}-gcc \
AR=${SINEWARE_TRIPLET}-ar \
RANLIB=${SINEWARE_TRIPLET}-ranlib \
./configure --prefix /usr
make -j$(nproc)
make install DESTDIR=$ROOTFS

# libelf
cd /build
wget https://sourceware.org/elfutils/ftp/0.182/elfutils-0.182.tar.bz2
tar xvf elfutils-0.182.tar.bz2
cd elfutils-0.182
./configure --prefix=/usr --host=${SINEWARE_TRIPLET} --build=${SINEWARE_TRIPLET} --disable-libdebuginfod --disable-debuginfod
make -j$(nproc)
make install DESTDIR=$ROOTFS

# pcre
cd /build
wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
tar xvf pcre-8.44.tar.gz
cd pcre-8.44
./configure --prefix=/usr --host=${SINEWARE_TRIPLET} --build=${SINEWARE_TRIPLET} --disable-libdebuginfod --disable-debuginfod
make -j$(nproc)
make install DESTDIR=$ROOTFS

# pcre2
cd /build
wget https://ftp.pcre.org/pub/pcre/pcre2-10.35.tar.gz
tar xvf pcre2-10.35.tar.gz
cd pcre2-10.35
./configure --prefix=/usr --host=${SINEWARE_TRIPLET} --build=${SINEWARE_TRIPLET} --disable-libdebuginfod --disable-debuginfod
make -j$(nproc)
make install DESTDIR=$ROOTFS

# libsepol
cd /build
wget https://github.com/SELinuxProject/selinux/releases/download/20200710/libsepol-3.1.tar.gz
tar xvf libsepol-3.1.tar.gz
cd libsepol-3.1

CC=${SINEWARE_TRIPLET}-gcc \
AR=${SINEWARE_TRIPLET}-ar \
RANLIB=${SINEWARE_TRIPLET}-ranlib \
make install DESTDIR=$ROOTFS

# libselinux
#cd /build
#wget https://github.com/SELinuxProject/selinux/releases/download/20200710/libselinux-3.1.tar.gz
#tar xvf libselinux-3.1.tar.gz
#cd libselinux-3.1
#
#CC=${SINEWARE_TRIPLET}-gcc \
#AR=${SINEWARE_TRIPLET}-ar \
#RANLIB=${SINEWARE_TRIPLET}-ranlib \
#make clean distclean
#
#CC=${SINEWARE_TRIPLET}-gcc \
#AR=${SINEWARE_TRIPLET}-ar \
#RANLIB=${SINEWARE_TRIPLET}-ranlib \
#make install DESTDIR=$ROOTFS

# libpixman
cd /build
wget https://www.cairographics.org/releases/pixman-0.40.0.tar.gz
tar xvf pixman-0.40.0.tar.gz
cd pixman-0.40.0

./configure --prefix /usr --host=${SINEWARE_TRIPLET} --build=${SINEWARE_TRIPLET}
make -j$(nproc)
make install DESTDIR=$ROOTFS

# ncurses/tinfo
/build-scripts/components/ncurses/build.sh

# util-linux
cd /build
wget https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz
tar xvf util-linux-2.36.tar.xz
cd util-linux-2.36

./configure --prefix /usr --host=${SINEWARE_TRIPLET} --build=${SINEWARE_TRIPLET} --disable-widechar
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd