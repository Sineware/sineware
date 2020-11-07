#!/usr/bin/env bash
set -e
echo "* Build Step: Bash *"
pushd .

cd /build
git clone $SINEWARE_REPO_BASH --depth 1
cd bash

./configure --prefix=/usr --without-bash-malloc --host=x86_64-sineware-linux-gnu --build=x86_64-sineware-linux-gnu
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd