#!/usr/bin/env bash
#  Copyright (C) 2020 Seshan Ravikumar
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -e # Crash when a command fails


echo "* Starting $SINEWARE_PRETTY_NAME build on $(date) *"
echo "Go get your noodles, this may take a while!"

# Source the global build config
source /buildmeta/buildconfig.sh

# Source the local build config
source /build-scripts/build-configuration.sh

echo "* Build Step: Getting Ready *"

mkdir -pv /tools

mkdir -pv /build/rootfs && cd /build

echo "* Build Step: Gathering Initial Components *"

cd /build

#wget ${SINEWARE_BIN_URL}/openwrt/${SINEWARE_BIN_OPENWRT}
tar xvf /artifacts/sineware-buildroot.tar.gz -C ${ROOTFS}

# ~~ Build the Toolchain, environment variables were set in build-configuration
# /build-scripts/toolchain/build.sh

echo "* Build Step: Preparing Directories *"

ls -l
ls -l $ROOTFS

echo "* Build Step: Adding files to rootfs *"
cp -rv /build-scripts/files/etc/* $ROOTFS/etc/
cp -rv /build-scripts/files/sineware.ini $ROOTFS/sineware.ini

echo "* Build Step: Adding Packages to the RootFS *"

# Prepare for chroot

# Packages

# Sineware Components
/build-scripts/components/insert-name/build.sh

# Clean up

echo "* Build Step: Creating rootfs archive *"
echo "This ${SINEWARE_PRETTY_NAME} build was completed on $(date)" > ./sineware-release
cd $ROOTFS
tar -czvf /artifacts/sineware.tar.gz .

du -h $ROOTFS
sleep 2

echo "* Done! *"