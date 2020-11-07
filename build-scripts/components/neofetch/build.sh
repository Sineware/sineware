#!/usr/bin/env bash
set -e
echo "* Build Step: neofetch *"
pushd .

git clone $SINEWARE_REPO_NEOFETCH --depth 1
cd neofetch
make install DESTDIR=$ROOTFS

popd