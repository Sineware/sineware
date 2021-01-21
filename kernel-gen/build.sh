#!/usr/bin/env bash
set -e
# x86_64 for now...
echo "* Build Step: It's Linux Time"
mkdir -pv /build
cd /build
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.9.tar.xz
tar xvf linux-5.10.9.tar.xz

cd linux-5.10.9

cp /build-scripts/files/x86_64-sineware-config .config
make -j$(nproc)

cp arch/x86/boot/bzImage /artifacts/
mkdir -v modules/
make modules_install INSTALL_MOD_PATH=./modules
cd modules && tar czvf /artifacts/linux-modules.tar.gz .

echo "* Done Kernel Build!"