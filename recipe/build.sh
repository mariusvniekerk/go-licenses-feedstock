#!/bin/bash
set -ex


GOBIN=$(go env GOBIN)
export GOBIN=$GOBIN

go install -v github.com/google/go-licenses

go-licenses save . --save_path=./license-files
rm -r ./license-files/github.com/google/licenseclassifier/licenses
