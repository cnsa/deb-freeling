#!/usr/bin/env bash

set -e

source ./vars.sh

docker create -v $REL_DIR \
              --name $DATA_C busybox /bin/true
docker build -t $B_I .
docker run --volumes-from $DATA_C --rm -t $B_I sh -c "rm -rf $DATA_LANG_RM && \
    make && \ 
    make install && \ 
    rm -rf $DATA_LANG_ALL && \
    checkinstall -y \
      --pkgsource="https://github.com/TALP-UPC/FreeLing/" \
      --pkglicense="GPL" \
      --deldesc=no \
      --backup=no \
      --nodoc \
      --install=no \
      --addso \
      --maintainer="api@cnsa.ru" \
      --pkgname=freeling \
      --pakdir="$REL_DIR" \
      --exclude="$DATA_LANG_ALL_DOT" \
      --provides="$PROVIDES" \
      --requires="$REQUIRES""
