#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

ARCH="$(rpm -E %{_arch})"
RELEASE="$(rpm -E %fedora)"

case "${KERNEL_FLAVOR}" in
"longterm"*)
    KERNEL_NAME="kernel-longterm"
    ;;
*)
    KERNEL_NAME="kernel"
    ;;
esac

pushd /tmp/rpms/kernel
KERNEL_VERSION=$(find "$KERNEL_NAME"-*.rpm | grep -P "$KERNEL_NAME-(\d+\.\d+\.\d+)-.*\.fc${RELEASE}\.${ARCH}" | sed -E "s/$KERNEL_NAME-//" | sed -E 's/\.rpm//')
popd

# mitigate problem on F43 where during kernel install, dracut errors and fails
# create a shim to bypass all of kernel-install... maybe not safe?
#mv /usr/sbin/kernel-install /usr/sbin/kernel-install.bak
#printf '%s\n' '#!/bin/sh' 'exit 0' > /usr/sbin/kernel-install
#mv -f /usr/sbin/kernel-install.bak /usr/sbin/kernel-install
#
# create a shim to bypass kernel install triggering dracut/rpm-ostree
# seems to be minimal impact, but allows progress on build
# NOTE: these shims are left in place permanently to support downstream
# builds, original files kept for reference
cd /usr/lib/kernel/install.d \
&& mv 05-rpmostree.install 05-rpmostree.install.original \
&& mv 50-dracut.install 50-dracut.install.original \
&& printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install \
&& printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install \
&& chmod +x  05-rpmostree.install 50-dracut.install
# instead of shims, could skip scriptlets: dnf install -y --setopt=tsflags=noscripts
# but skipping all scriptlets for kernel install may not be safe

# Replace Existing Kernel with packages from akmods cached kernel
for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
    if rpm -q $pkg >/dev/null 2>&1; then
        rpm --erase $pkg --nodeps
    fi
done
echo "Install $KERNEL_NAME version ${KERNEL_VERSION} from kernel-cache."
dnf -y install \
    /tmp/rpms/kernel/"$KERNEL_NAME"-[0-9]*.rpm \
    /tmp/rpms/kernel/"$KERNEL_NAME"-core-*.rpm \
    /tmp/rpms/kernel/"$KERNEL_NAME"-modules-*.rpm

# Ensure kernel packages can't be updated by other dnf operations
dnf versionlock add "$KERNEL_NAME" "$KERNEL_NAME"-core "$KERNEL_NAME"-modules "$KERNEL_NAME"-modules-core "$KERNEL_NAME"-modules-extra

## ALWAYS: install ZFS (and sanoid deps)
# uCore does not support ZFS as rootfs, thus does not provide it in the initramfs
dnf -y install /tmp/rpms/akmods-zfs/kmods/zfs/*.rpm /tmp/rpms/akmods-zfs/kmods/zfs/other/zfs-dracut-*.rpm
# for some reason depmod ran automatically with zfs 2.1 but not with 2.2
echo "Update modules.dep, etc..."
depmod -a "${KERNEL_VERSION}"

echo "::endgroup::"
