#!/usr/bin/env bash

set -e

source ./vars.sh

DEST="./packages/FreeLing-${VERSION}.tar.gz"
URL="https://github.com/TALP-UPC/FreeLing/releases/download/${VERSION}/FreeLing-${VERSION}.tar.gz"

if [ ! -f "$DEST" ]; then
  curl -o "$DEST" -L "$URL"
fi
