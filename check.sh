#!/usr/bin/env bash

set -e

source ./vars.sh

# docker run --volumes-from $DATA_C -t $B_I sh -c "apt-get -qqy install fakeroot && mkdir /build && make -j 4 && fakeroot make install DESTDIR=/build && ls -all /build"
docker run --volumes-from $DATA_C --rm -t $B_I sh -c "ls -all $REL_DIR"
# docker run --volumes-from $DATA_C --rm -t $B_I sh -c "make install && \
# rm -rf $DATA_LANG_ALL && \
# checkinstall -y \
#   --pkgsource="https://github.com/TALP-UPC/FreeLing/" \
#   --pkglicense="GPL" \
#   --deldesc=no \
#   --backup=no \
#   --nodoc \
#   --install=no \
#   --addso \
#   --maintainer="api@cnsa.ru" \
#   --pkgname=freeling \
#   --pakdir="$REL_DIR" \
#   --exclude="$DATA_LANG_ALL_DOT" \
#   --provides="$PROVIDES" \
#   --requires="$REQUIRES""
# docker run --volumes-from $DATA_C --rm -t $B_I sh -c "rm -rf $DATA_LANG_RM && rm -rf $DATA_LANG_CFG && sed -i -- 's/as ca cs cy de en es fr gl hr it nb pt ru sl/en ru/' $APP_DIR/data/Makefile && cd $APP_DIR/data && make install && ls -all $APP_DIR/data"
