#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

modules=(
    "base/01-setup-dnf.sh"
    "base/02-setup-kernel.sh"
    "base/03-install-copr-repos.sh"
    "base/04-packages.sh"
    "hw/base/packages.sh"
    "base/08-firmware.sh"
    "base/10-services.sh"
    # "sign.sh"
    "initramfs.sh"
)

for mod in "${modules[@]}"; do
    path="/ctx/build_files/${mod}"
    echo "::group:: === $(basename "$path") ==="
    bash "$path"
    echo "::endgroup::"
done

mkdir -p /etc/pki/containers
cp /ctx/cosign.pub /etc/pki/containers/ublue-fedora.pub
chmod 0644 /etc/pki/containers/ublue-fedora.pub

/ctx/build_files/base/200-cleanup.sh

echo "::endgroup::"
