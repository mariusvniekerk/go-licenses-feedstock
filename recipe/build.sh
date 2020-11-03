#!/bin/bash
set -ex


GOBIN=$(go env GOBIN)
export GOBIN=$GOBIN

go get -v github.com/google/go-licenses

mkdir -p "${PREFIX}/share/go-licenses"
cp \
  "${GOPATH:-"$( go env GOPATH )"}"/pkg/mod/github.com/google/licenseclassifier*/licenses/licenses.db \
  "${PREFIX}/share/go-licenses/"

go-licenses save $SRC_DIR --save_path="$RECIPE_DIR/thirdparty_licenses/"
