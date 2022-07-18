#!/bin/bash

export GOBIN
GOBIN=$(go env GOBIN)

if [[ "${target_platform}" == "osx-64" ]]; then
  export GOOS=darwin
  export GOARCH=amd64
elif [[ "${target_platform}" == "osx-arm64" ]]; then
  export GOOS=darwin
  export GOARCH=arm64
elif [[ "${target_platform}" == "linux-aarch64" ]]; then
  export GOOS=linux
  export GOARCH=arm64
elif [[ "${target_platform}" == "linux-ppc64le" ]]; then
  export GOOS=linux
  export GOARCH=ppc64le
fi

go install -v github.com/google/go-licenses

go-licenses save . --save_path=./license-files
# TODO: remove if not actually needed, see #6
# rm -r ./license-files/github.com/google/licenseclassifier/licenses

# Make GOPATH directories writeable so conda-build can clean everything up.
find "$( go env GOPATH )" -type d -exec chmod +w {} \;
