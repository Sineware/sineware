#!/usr/bin/env bash
set -e
echo "* Build Step: htop *"
pushd .

cd /build
git clone $SINEWARE_REPO_HTOP --depth 1
cd htop

export CPPFLAGS='-I${ROOTFS}/usr/include/'
export LDFLAGS='-L${ROOTFS}/lib/:${ROOTFS}/lib64/:${ROOTFS}/usr/lib/:${ROOTFS}/usr/lib64/'

./autogen.sh
./configure --prefix /usr
make -j$(nproc)
make install DESTDIR=$ROOTFS

popd