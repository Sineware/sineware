#!/usr/bin/env bash
set -e
echo "* Build Step: Inserting Sineware Names Using sed *"
pushd .

# See build-configuration.sh

cd $ROOTFS
sed -i "s/SINEWARE_ID/$SINEWARE_ID/" ./etc/os-release
sed -i "s/SINEWARE_VERSION_ID/$SINEWARE_VERSION_ID/" ./etc/os-release

sed -i "s/SINEWARE_NAME/$SINEWARE_NAME/" ./etc/os-release
sed -i "s/SINEWARE_VERSION/$SINEWARE_VERSION/" ./etc/os-release
sed -i "s/SINEWARE_PRETTY_NAME/$SINEWARE_PRETTY_NAME/" ./etc/os-release

sed -i "s/SINEWARE_PRETTY_NAME/$SINEWARE_PRETTY_NAME/" ./etc/issue
popd