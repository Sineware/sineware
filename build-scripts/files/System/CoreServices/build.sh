#!/usr/bin/env bash
set -e
echo "* Build Step: CoreServices *"
pushd .
cd /build-scripts/files/System/CoreServices
mkdir -pv $ROOTFS/System/CoreServices

go get -u github.com/gin-gonic/gin
go build -o $ROOTFS/System/CoreServices/CoreServices src/main.go
popd