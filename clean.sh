#!/usr/bin/env bash

set -e

source ./vars.sh

docker rm -f $DATA_C 2>/dev/null || true
