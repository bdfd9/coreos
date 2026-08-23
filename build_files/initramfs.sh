#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -ouex pipefail

KVER=$(ls /usr/lib/modules | head -n1)

dnf5 -y install dropbear dracut-network systemd-networkd

depmod -a "$KVER"
export DRACUT_NO_XATTR=1
/usr/bin/dracut \
  --no-hostonly \
  --kver "$KVER" \
  --reproducible \
  --xz \
  --verbose \
  --omit "qemu qemu-net zfs fido2 iscsi" \
  --add ostree \
  -f "/usr/lib/modules/$KVER/initramfs.img"

chmod 0600 "/usr/lib/modules/$KVER/initramfs.img"

dnf5 -y remove dropbear dracut-network

echo "::endgroup::"
