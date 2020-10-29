#!/usr/bin/env bash
set -e
# todo remove this eventually! this is bad
echo "* Build Step: Library Patches *"
pushd .

# gcc
cp /lib64/libgcc_s.so.1 $ROOTFS/lib64/libgcc_s.so.1

# libstdc++
cp -r /usr/lib64/libstdc++.so.6.0.28 $ROOTFS/usr/lib64/
cp -r /usr/lib64/libstdc++.so.6 $ROOTFS/usr/lib64/

# ncurses (and tinfo)
cp -r /lib64/libtinfo.so.6.1 $ROOTFS/lib64/
cp -r /lib64/libtinfo.so.6 $ROOTFS/lib64/

cp -r /lib64/libtinfo.so.5.9 $ROOTFS/lib64/
cp -r /lib64/libtinfo.so.5 $ROOTFS/lib64/

cp -r /lib64/libncurses.so.5.9 $ROOTFS/lib64/
cp -r /lib64/libncurses.so.5 $ROOTFS/lib64/

# OpenSSL
cp -r /usr/lib64/libcrypto.so.1.1 $ROOTFS/usr/lib64/
cp -r /usr/lib64/libcrypto.so $ROOTFS/usr/lib64/

# libz
cp -r /lib64/libz.so.1.2.11 $ROOTFS/lib64/
cp -r /lib64/libz.so.1 $ROOTFS/lib64/

popd