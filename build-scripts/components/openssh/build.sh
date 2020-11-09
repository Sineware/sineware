#!/usr/bin/env bash
set -e
echo "* Build Step: OpenSSH *"
pushd .

cd /build
git clone $SINEWARE_REPO_OPENSSH
cd openssh

autoreconf
./configure --prefix=/usr --host=${SINEWARE_TRIPLET} --build=${SINEWARE_TRIPLET}
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd