#!/usr/bin/env bash
set -e
echo "* Build Step: GLib *"
pushd .

cd /build
git clone $SINEWARE_REPO_GLIB --depth 1
cd GLib

meson _build --prefix /usr
ninja -C _build
DESTDIR=$ROOTFS ninja -C _build install

popd