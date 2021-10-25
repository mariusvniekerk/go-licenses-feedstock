#!/bin/bash

export GOBIN
GOBIN=$(go env GOBIN)

go install -v github.com/google/go-licenses

go-licenses save . --save_path=./license-files
rm -r ./license-files/github.com/google/licenseclassifier/licenses

# Make GOPATH directories writeable so conda-build can clean everything up.
find "$( go env GOPATH )" -type d -exec chmod +w {} \;
