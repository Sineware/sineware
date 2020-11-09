#!/usr/bin/env bash
set -e
echo "* Build Step: ncurses *"
pushd .

cd /build
git clone $SINEWARE_REPO_NCURSES --depth 1
cd ncurses

./configure --prefix=/usr           \
            --with-shared           \
            --without-debug         \
            --enable-pc-files       \
            --enable-widec          \
            --host=${SINEWARE_TRIPLET} --build=${SINEWARE_TRIPLET}

make -j$(nproc)
make install DESTDIR=$ROOTFS

cd $ROOTFS/usr/lib
ln -s libncursesw.so libcurses.so
ln -s libncursesw.a libcurses.a

popd