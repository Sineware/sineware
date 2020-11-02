#!/bin/bash
set -e
mkdir -p build-scripts/output
rm -rf build-scripts/output/*
docker build . -t sineware-build
exec docker run -i -v "$(pwd)"/build-scripts:/build-scripts --rm sineware-build