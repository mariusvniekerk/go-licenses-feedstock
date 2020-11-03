#!/bin/bash
set -ex


GOBIN=$(go env GOBIN)
export GOBIN=$GOBIN

go get -d github.com/google/go-licenses
# Copy our patched vendored source before starting the build.
cp -rf \
  licenseclassifier-${licenseclassifier_commit}/* \
  "${GOPATH:-"$( go env GOPATH )"}"/pkg/mod/github.com/google/licenseclassifier@*-${licenseclassifier_commit}/
go get -v github.com/google/go-licenses

mkdir -p "${PREFIX}/share/go-licenses"
cp \
  "${GOPATH:-"$( go env GOPATH )"}"/pkg/mod/github.com/google/licenseclassifier@*-${licenseclassifier_commit}/licenses/licenses.db \
  "${PREFIX}/share/go-licenses/"


# If/when https://github.com/conda/conda-build/issues/4121 is supported, the
# following can be greatly simplified.
gather_licenses() {
  # shellcheck disable=SC2039  # Allow widely supported non-POSIX local keyword.
  local module output tmp_dir acc_dir
  output="${1}"
  shift
  tmp_dir="$(pwd)/gather-licenses-tmp"
  acc_dir="$(pwd)/gather-licenses-acc"
  mkdir "${acc_dir}"
  cat > "${output}" <<'EOF'
--------------------------------------------------------------------------------
The output below is generated with `go-licenses csv` and `go-licenses save`.
================================================================================
EOF
  for module ; do
    cat >> "${output}" <<EOF

go-licenses csv ${module}
================================================================================
EOF
    go-licenses csv "${module}" | sort >> "${output}"
    go-licenses save "${module}" --save_path="${tmp_dir}"
    cp -r "${tmp_dir}"/* "${acc_dir}"/
    rm -r "${tmp_dir}"
  done
  # shellcheck disable=SC2016  # Not expanding $ in single quotes intentional.
  find "${acc_dir}" -type f | sort | xargs -L1 sh -c '
cat <<EOF

--------------------------------------------------------------------------------
${2#${1%/}/}
================================================================================
EOF
cat "${2}"
' -- "${acc_dir}" >> "${output}"
  rm -r "${acc_dir}"
}

gather_licenses ./thirdparty-licenses.txt .
