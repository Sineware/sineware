#!/bin/bash
rm -rf iso-build-scripts/output/*
cp build-scripts/output/sineware.tar.gz iso-build-scripts/files/sineware.tar.gz
docker build . -t sineware-build
exec docker run -t -i -v "$(pwd)"/iso-build-scripts:/build-scripts --rm sineware-build