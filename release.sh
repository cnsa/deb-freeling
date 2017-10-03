#!/usr/bin/env bash

set -e

PROJECT="freeling"
VERSION="4.0"
APP_DIR="/tmp/FreeLing-$VERSION"
REL_DIR="/data/FreeLing-$VERSION"
DATA_C="build_""$PROJECT""_data_$VERSION"
B_I="project-build-$PROJECT:$VERSION"

PROVIDES="freeling,libfreeling,libtreeler,libfoma"

LIBBOOST="1.62"
LIBBOOST_DEP="$LIBBOOST.0"
LIBICU="57"
LIBICU_DEP="$LIBICU.0"

REQUIRES="libstdc++6 \(\>=4.6.3\),libgcc1 \(\>=4.6.3\),libc6 \(\>=2.13\),zlib1g \(\>=1.2.3\),libboost-program-options$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-regex$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-filesystem$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-system$LIBBOOST_DEP \(\>=$LIBBOOST\),libicu$LIBICU \(\>=$LIBICU_DEP\),zlib1g \(\>=1.2.3.4\)"

function data_rm_paths() {
  FREELING_SHARE="$1"
  echo "$FREELING_SHARE/as \
      $FREELING_SHARE/ca \
      $FREELING_SHARE/cs \
      $FREELING_SHARE/cy \
      $FREELING_SHARE/de \
      $FREELING_SHARE/es \
      $FREELING_SHARE/fr \
      $FREELING_SHARE/gl \
      $FREELING_SHARE/hr \
      $FREELING_SHARE/nb \
      $FREELING_SHARE/it \
      $FREELING_SHARE/pt \
      $FREELING_SHARE/sl"
}

DATA_LANG_RM=$(data_rm_paths "data")
DATA_LANG_RM_INST=$(data_rm_paths "/usr/share/freeling")
DATA_LANG_ALL="$DATA_LANG_RM\ $DATA_LANG_RM_INST"

ARCH="amd64"
FN="$PROJECT""_$VERSION-1_$ARCH.deb"

docker rm -f $DATA_C 2>/dev/null || true
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
      --maintainer="Alexander Merkulov\\<api@cnsa.ru\\>" \
      --pkgname=freeling \
      --exclude="$DATA_LANG_ALL" \
      --provides="$PROVIDES" \
      --requires="$REQUIRES" && \    
      mv *.deb $REL_DIR/"
mkdir -p releases/$VERSION
docker cp $DATA_C:$REL_DIR/$FN releases/$VERSION/$FN
docker rm -f $DATA_C 2>/dev/null || true
docker rmi $B_I
