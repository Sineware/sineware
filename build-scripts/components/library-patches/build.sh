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
./configure --prefix=/usr --host=x86_64-sineware-linux-gnu --build=x86_64-sineware-linux-gnu --disable-libdebuginfod --disable-debuginfod
make -j$(nproc)
make install DESTDIR=$ROOTFS

# libpcre3
cd /build
wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
tar xvf pcre-8.44.tar.gz
cd pcre-8.44
./configure --prefix=/usr --host=x86_64-sineware-linux-gnu --build=x86_64-sineware-linux-gnu --disable-libdebuginfod --disable-debuginfod
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
cd /build
wget https://github.com/SELinuxProject/selinux/releases/download/20200710/libselinux-3.1.tar.gz
tar xvf libselinux-3.1.tar.gz
cd libselinux-3.1

CC=${SINEWARE_TRIPLET}-gcc \
AR=${SINEWARE_TRIPLET}-ar \
RANLIB=${SINEWARE_TRIPLET}-ranlib \
make clean distclean

CC=${SINEWARE_TRIPLET}-gcc \
AR=${SINEWARE_TRIPLET}-ar \
RANLIB=${SINEWARE_TRIPLET}-ranlib \
make install DESTDIR=$ROOTFS

# gcc
#cp -v /lib64/libgcc_s.so.1 $ROOTFS/lib64/libgcc_s.so.1

# libstdc++
#cp -rv /usr/lib64/libstdc++.so.6.0.28 $ROOTFS/usr/lib64/
#cp -rv /usr/lib64/libstdc++.so.6 $ROOTFS/usr/lib64/

# todo remove the cp's eventually! this is bad

# OpenSSL
#cp -rv /usr/lib64/libcrypto.so.1.1 $ROOTFS/usr/lib64/
#cp -rv /usr/lib64/libcrypto.so $ROOTFS/usr/lib64/

# libz
#cp -rv /lib64/libz.so.1.2.11 $ROOTFS/lib64/
#cp -rv /lib64/libz.so.1 $ROOTFS/lib64/

popd