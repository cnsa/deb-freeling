#!/usr/bin/env bash

set -e

source ./vars.sh

mkdir -p releases/$VERSION
docker cp $DATA_C:$REL_DIR/$FN releases/$VERSION/$FN
