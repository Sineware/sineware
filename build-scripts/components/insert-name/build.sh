#!/usr/bin/env bash
set -e
echo "* Build Step: Inserting Sineware Names Using sed *"
pushd .

# See buildmeta/buildconfig.sh (generated)

cd $ROOTFS

sed -i "s/SINEWARE_PRODUCT/${SINEWARE_PRODUCT}/" ./sineware.ini
sed -i "s/SINEWARE_BUILD/${SINEWARE_BUILD}/" ./sineware.ini
sed -i "s/SINEWARE_CHANNEL/${SINEWARE_CHANNEL}/" ./sineware.ini

sed -i "s/SINEWARE_PRETTY_NAME/${SINEWARE_PRETTY_NAME}/" ./etc/banner
sed -i "s/SINEWARE_PRETTY_VERSION/${SINEWARE_PRETTY_VERSION}/" ./etc/banner
sed -i "s/SINEWARE_CHANNEL/${SINEWARE_CHANNEL}/" ./etc/banner


sed -i "s/SINEWARE_PRETTY_NAME/${SINEWARE_PRETTY_NAME}/" ./etc/os-release
sed -i "s/SINEWARE_PRETTY_VERSION/${SINEWARE_PRETTY_VERSION}/" ./etc/os-release
sed -i "s/SINEWARE_PRODUCT/${SINEWARE_PRODUCT}/" ./etc/os-release
sed -i "s/SINEWARE_BUILD/${SINEWARE_BUILD}/" ./etc/os-release


popd