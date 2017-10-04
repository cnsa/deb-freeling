#!/usr/bin/env bash

set -e

source ./vars.sh

FPM="fpm --epoch 1 \
-C $BUILD \
-s dir \
-p $REL_DIR \
-a amd64 \
-m 'NSA Ltd. <api@cnsa.ru>' \
--description 'FreeLing is a tool' \
--license 'GPL' \
--uri 'https://github.com/TALP-UPC/FreeLing/' \
--post-install $APP_DIR/debian/postinst \
--post-uninstall $APP_DIR/debian/postrm \
--pre-uninstall $APP_DIR/debian/prerm \
--provides freeling \
--provides libfreeling \
--provides libtreeler \
--provides libfoma \
-v '4.0' \
-t deb \
-d 'libstdc++6 (>=4.6.3)' \
-d 'libgcc1 (>=4.6.3)' \
-d 'libc6 (>=2.13)' \
-d 'zlib1g (>=1.2.3)' \
-d 'libboost-program-options$LIBBOOST_DEP (>=$LIBBOOST)' \
-d 'libboost-regex$LIBBOOST_DEP (>=$LIBBOOST)' \
-d 'libboost-filesystem$LIBBOOST_DEP (>=$LIBBOOST)' \
-d 'libboost-system$LIBBOOST_DEP (>=$LIBBOOST)' \
-d 'libicu$LIBICU (>=$LIBICU_DEP)' \
-d 'zlib1g (>=1.2.3.4)' \
-n freeling"

docker create -v $REL_DIR \
              --name $DATA_C busybox /bin/true
docker build -t $B_I .
docker run --volumes-from $DATA_C --rm -t $B_I sh -c "rm -rf $DATA_LANG_RM && \
    rm -rf $DATA_LANG_CFG && \ 
    sed -i -- 's/as ca cs cy de en es fr gl hr it nb pt ru sl/en ru/' $APP_DIR/data/Makefile && \
    make -j 4 && \ 
    mkdir -p $BUILD && \
    fakeroot make install DESTDIR=$BUILD && \
    rm -rf $DATA_LANG_ALL && \
    $FPM"
