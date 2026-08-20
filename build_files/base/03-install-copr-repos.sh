#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

echo "::group:: ===List of preinstalled packages==="
rpm -qa
echo "::endgroup::"

coprs=(
)

for copr in "${coprs[@]}"; do
    echo "Enabling copr: $copr"
    dnf5 -y copr enable "$copr"
done

echo "::endgroup::"
