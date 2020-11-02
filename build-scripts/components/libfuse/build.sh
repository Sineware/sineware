#!/usr/bin/env bash
set -e
echo "* Build Step: libfuse *"
pushd .

cd /build
git clone $SINEWARE_REPO_LIBFUSE --depth 1
cd libfuse

./makeconf.sh
./configure --prefix=/usr

make -j$(nproc)
make install DESTDIR=$ROOTFS
libtool --finish $ROOTFS/usr/lib

popd