#!/bin/bash
set -e
mkdir -p build-scripts/output
rm -rf build-scripts/output/*
docker build . -t sineware-build

if [ "$SINEWARE_DEVELOPMENT" = true ]
then
  exec docker run -i -t -v "$(pwd)"/build-scripts:/build-scripts --rm --env SINEWARE_DEVELOPMENT=true sineware-build
else
  exec docker run -i -v "$(pwd)"/build-scripts:/build-scripts --rm sineware-build
fi