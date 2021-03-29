#!/usr/bin/env bash
set -e

echo "* Building the RootFS with buildroot... *"
cd buildroot
echo "  * Reading configuration files..."
make BR2_EXTERNAL=../br2external BR2_DEFCONFIG=../br2external/configs/prolinuxserver_defconfig defconfig
echo "  * Starting Build! 🚀"
make