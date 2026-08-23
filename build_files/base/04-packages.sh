#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

dnf5 -y install terra-release-mesa

dnf5 -y install mesa-va-drivers \
    mesa-vulkan-drivers

packages=(
    # Admin
    cockpit-files
    cockpit-machines
    cockpit-networkmanager
    cockpit-podman
    cockpit-selinux
    cockpit-storaged
    cockpit-system
    cockpit-ostree

    # Audio / Firmware
    atheros-firmware
    brcmfmac-firmware
    iwlegacy-firmware
    iwlwifi-dvm-firmware
    iwlwifi-mvm-firmware
    mt7xxx-firmware
    nxpwireless-firmware
    realtek-firmware
    tiwilink-firmware

    # Containers
    distrobox
    podman-compose
    podman-machine
    podman-tui
    podmansh
    systemd-container

    # Network / Connectivity
    iftop
    net-tools
    NetworkManager
    NetworkManager-adsl
    NetworkManager-config-connectivity-fedora
    NetworkManager-libnm
    NetworkManager-openconnect
    NetworkManager-openvpn
    NetworkManager-ssh
    NetworkManager-ssh-selinux
    NetworkManager-strongswan
    NetworkManager-vpnc
    NetworkManager-wifi
    NetworkManager-wwan
    openconnect
    spoofdpi
    vpnc
    wireguard-tools


    # Security / Authentication
    audispd-plugins
    audit
    clevis
    firewalld
    git-credential-libsecret
    ksshaskpass
    pam_yubico
    yubikey-manager

    # Performance

    # power-profiles-daemon
    thermald

    # System / Utilities
    acpica-tools
    adcli
    ansible
    bash-color-prompt
    bootc
    bpftool
    curl
    ddcutil
    evtest
    fuse
    fuse-common
    fuse-encfs
    fwupd
    hdparm
    htop
    inotify-tools
    iotop-c
    lm_sensors
    lshw
    man-db
    man-pages
    nvme-cli
    openssl
    perf
    powerstat
    powertop
    rclone
    restic
    rsync
    setools-console
    shadow-utils
    smartmontools
    stow
    strace
    symlinks
    tcpdump
    tmux
    traceroute
    unzip
    usb_modeswitch
    usbutils
    uxplay
    vim
    whois
    xdg-terminal-exec
    xdg-user-dirs
    zstd

    # Fonts
    default-fonts
    default-fonts-core-emoji
    fira-code-fonts
    google-noto-color-emoji-fonts
    google-noto-emoji-fonts
    google-noto-fonts-all
    liberation-fonts

    # SMB
    samba
    samba-dcerpc
    samba-ldb-ldap-modules
    samba-usershares
    samba-winbind-clients
    samba-winbind-modules

    # Extra
    fastfetch
    firewall-config
    flatpak
    flatpak-spawn
    glx-utils
    tailscale

    # Shell
    zsh

    # Dev tools
    git
    jq
    just
    make
    ninja
    python3
    python3-pip
    ripgrep
    tio
    tokei
    uv

    # Virtualization
    libvirt
    qemu
    qemu-char-spice
    qemu-device-display-virtio-gpu
    qemu-device-display-virtio-vga
    qemu-device-usb-redirect
    qemu-img
    qemu-system-x86-core
    qemu-user-binfmt
    qemu-user-static
)

dnf5 -y install "${packages[@]}"

packages_to_remove=(
    podman-docker
)

dnf5 -y remove "${packages_to_remove[@]}"

echo "::endgroup::"
