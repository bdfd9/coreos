#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 -y install intel-compute-runtime
dnf5 -y install igt-gpu-tools
# dnf5 -y install libva-intel-media-driver

dnf5 -y install libva-intel-driver
dnf5 -y swap libva-intel-media-driver intel-media-driver --allowerasing

echo "::endgroup::"
