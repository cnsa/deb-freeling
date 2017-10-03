#!/usr/bin/env bash

set -e

PROJECT="freeling"
VERSION="4.0"
APP_DIR="/tmp/FreeLing-$VERSION"
REL_DIR="/data/FreeLing-$VERSION"
DATA_C="build_""$PROJECT""_data_$VERSION"
B_I="project-build-$PROJECT:$VERSION"

ARCH="amd64"
FN="$PROJECT_$VERSION-1_$ARCH.deb"

docker rm -f $DATA_C 2>/dev/null || true
docker create -v $REL_DIR \
              --name $DATA_C busybox /bin/true
docker build -t $B_I .
docker run --volumes-from $DATA_C \
           sh -c "mv *.deb $REL_DIR/"
mkdir -p releases/$VERSION
docker cp $DATA_C:$REL_DIR/$FN releases/$VERSION/$FN
docker rm -f $DATA_C 2>/dev/null || true
docker rmi $B_I
