#!/usr/bin/env bash
set -e
echo "* Build Step: GLib *"
pushd .

cd /build
git clone $SINEWARE_REPO_GLIB --depth 1
cd GLib

export CC=${SINEWARE_TRIPLET}-gcc
export CXX=${SINEWARE_TRIPLET}-g++

meson _build --prefix /usr -Dinternal_pcre=true -Dselinux=disabled -Ddtrace=false  -Dsystemtap=false -Db_coverage=false -Dinstalled_tests=false -Dgtk_doc=false
ninja -C _build
DESTDIR=$ROOTFS ninja -C _build install

popd