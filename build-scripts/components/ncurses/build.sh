#!/usr/bin/env bash
set -e
echo "* Build Step: ncurses *"
pushd .

cd /build
git clone $SINEWARE_REPO_NCURSES --depth 1
cd ncurses

./configure --prefix=/usr --with-termlib=tinfo --enable-widec --with-shared
make -j$(nproc)
make install DESTDIR=$ROOTFS

cd $ROOTFS/lib64

popd