#!/usr/bin/env bash
set -e
echo "* Build Step: QEMU *"
pushd .

cd /build
git clone $SINEWARE_REPO_QEMU --depth 1
cd qemu

mkdir build
cd build
../configure --prefix=/usr --target-list=x86_64-softmmu \
             --cc=x86_64-sineware-linux-gnu-gcc \
             --cxx=x86_64-sineware-linux-gnu-g++
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd