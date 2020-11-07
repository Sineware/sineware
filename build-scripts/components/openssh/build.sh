#!/usr/bin/env bash
set -e
echo "* Build Step: OpenSSH *"
pushd .

cd /build
git clone $SINEWARE_REPO_OPENSSH
cd openssh

autoreconf
./configure --prefix=/usr --host=x86_64-sineware-linux-gnu --build=x86_64-sineware-linux-gnu
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd