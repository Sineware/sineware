#!/usr/bin/env bash
set -e
echo "* Build Step: htop *"
pushd .

cd /build
git clone $SINEWARE_REPO_HTOP --depth 1
cd htop

./autogen.sh
./configure --prefix /usr --host=x86_64-sineware-linux-gnu --build=x86_64-sineware-linux-gnu
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd