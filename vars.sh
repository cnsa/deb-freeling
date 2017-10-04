#!/usr/bin/env bash

export PROJECT="freeling"
export VERSION="4.0"
export APP_DIR="/tmp/FreeLing-$VERSION"
export REL_DIR="/data/FreeLing-$VERSION"
export BUILD="/build"
export DATA_C="build_""$PROJECT""_data_$VERSION"
export B_I="project-build-$PROJECT:$VERSION"

export PROVIDES="freeling,libfreeling,libtreeler,libfoma"

export LIBBOOST="1.62"
export LIBBOOST_DEP="$LIBBOOST.0"
export LIBICU="57"
export LIBICU_DEP="$LIBICU.0"

export REQUIRES="libstdc++6 \(\>=4.6.3\),libgcc1 \(\>=4.6.3\),libc6 \(\>=2.13\),zlib1g \(\>=1.2.3\),libboost-program-options$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-regex$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-filesystem$LIBBOOST_DEP \(\>=$LIBBOOST\),libboost-system$LIBBOOST_DEP \(\>=$LIBBOOST\),libicu$LIBICU \(\>=$LIBICU_DEP\),zlib1g \(\>=1.2.3.4\)"

LIST=(as ca cs cy ca-balear ca-valencia es-old es-ar de es fr gl hr nb it pt sl)
LIST_LAST="sl"

function data_rm_paths() {
  FREELING_SHARE="$1"
  
  for item in ${LIST[*]}
  do
    printf "%s/%s/* " $FREELING_SHARE $item
  done
}

function data_rm_cfg_paths() {
  FREELING_SHARE="$1"
  
  for item in ${LIST[*]}
  do
    printf "%s/%s.cfg " $FREELING_SHARE $item
  done
}

function data_rm_inst_paths() {
  FREELING_SHARE="$1"
  
  for item in ${LIST[*]}
  do
    printf "%s/%s" $FREELING_SHARE $item
    if [ "$item" != "$LIST_LAST" ]; then printf ","; fi
  done
}

export DATA_LANG_CFG=$(data_rm_cfg_paths "$APP_DIR/data/config")
export DATA_LANG_CFG_INST=$(data_rm_cfg_paths "/usr/share/freeling/config")
export DATA_LANG_RM=$(data_rm_paths "$APP_DIR/data")
export DATA_LANG_RM_INST=$(data_rm_paths "/usr/share/freeling")
export DATA_LANG_RM_BUILD=$(data_rm_paths "$BUILD/usr/share/freeling")
export DATA_LANG_DOT=$(data_rm_inst_paths "$APP_DIR/data")
export DATA_LANG_DOT_INST=$(data_rm_inst_paths "/usr/share/freeling")
export DATA_LANG_ALL="$DATA_LANG_RM\ $DATA_LANG_RM_INST\ $DATA_LANG_RM_BUILD"
export DATA_LANG_ALL_DOT="$DATA_LANG_DOT,$DATA_LANG_DOT_INST"

export ARCH="amd64"
export FN="$PROJECT""_"$VERSION"_$ARCH.deb"
