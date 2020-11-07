#!/usr/bin/env bash
set -e
echo "* Build Step: Preparing the Toolchain *"
pushd .
cd /build
wget $SINEWARE_BIN_URL/$SINEWARE_BIN_TOOLCHAIN
mkdir -pv toolchain && cd toolchain
tar -xvf ../$SINEWARE_BIN_TOOLCHAIN

popd
#export SINEWARE_GCC_TARGET=${SINEWARE_ARCH}-sineware-linux-gnu
#export PREFIX="/tools"
#export PATH="$PREFIX/bin:$PATH"
#
#echo "    -> GNU Binutils"
#pushd .
#cd /build
#git clone $SINEWARE_REPO_BINUTILS --depth 1
#cd binutils
#mkdir -pv build && cd build
#
#../configure --target=$SINEWARE_GCC_TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
#
#make -j$(nproc)
#make install
#bash
#popd
#
#echo "    -> GCC"
#pushd .
#cd /build
#
#git clone $SINEWARE_REPO_GCC --depth 1
#cd gcc
#contrib/download_prerequisites
#mkdir -pv build && cd build
#
#../configure --target=$SINEWARE_GCC_TARGET --prefix=$PREFIX --disable-multilib --disable-nls --enable-languages=c,c++ --without-headers \
#
#make -j$(nproc)
#make install
#bash
#
#popd