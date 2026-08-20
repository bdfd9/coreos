#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

system_services=(
    bootc-fetch-apply-updates.service
    podman.socket
    chronyd.service
    firewalld.service
    systemd-resolved.service
    tailscaled.service
)

user_services=(
    podman.socket
    ssh-agent.service
    gpg-agent.service
)

mask_services=(
    flatpak-add-fedora-repos.service
    NetworkManager-wait-online.service
)

systemctl enable "${system_services[@]}"
systemctl mask "${mask_services[@]}"
systemctl --global enable "${user_services[@]}"

preset_file="/usr/lib/systemd/system-preset/01-internal-preset.preset"
touch "$preset_file"

for service in "${system_services[@]}"; do
    echo "enable $service" >> "$preset_file"
done

mkdir -p "/etc/systemd/user-preset/"
preset_file="/etc/systemd/user-preset/01-internal-preset.preset"
touch "$preset_file"

for service in "${user_services[@]}"; do
    echo "enable $service" >> "$preset_file"
done

systemctl --global preset-all

echo "::endgroup::"
