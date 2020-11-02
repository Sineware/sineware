#!/usr/bin/env bash
set -e
# todo remove this eventually! this is bad
echo "* Build Step: Library Patches *"
pushd .

# gcc
cp -v /lib64/libgcc_s.so.1 $ROOTFS/lib64/libgcc_s.so.1

# libstdc++
cp -rv /usr/lib64/libstdc++.so.6.0.28 $ROOTFS/usr/lib64/
cp -rv /usr/lib64/libstdc++.so.6 $ROOTFS/usr/lib64/

# OpenSSL
cp -rv /usr/lib64/libcrypto.so.1.1 $ROOTFS/usr/lib64/
cp -rv /usr/lib64/libcrypto.so $ROOTFS/usr/lib64/

# libz
cp -rv /lib64/libz.so.1.2.11 $ROOTFS/lib64/
cp -rv /lib64/libz.so.1 $ROOTFS/lib64/

popd