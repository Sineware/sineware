#!/usr/bin/env bash
echo "* Build Step: OpenSSH *"
pushd .

cd /build
git clone $SINEWARE_REPO_OPENSSH
cd openssh

autoreconf
./configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd