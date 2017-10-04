#!/usr/bin/env bash

set -e

source ./vars.sh

docker run --volumes-from $DATA_C --rm -t $B_I sh -c "ls -all $REL_DIR"
