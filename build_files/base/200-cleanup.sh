#!/usr/bin/env bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

# rm -rf /tmp/* || true
# rm -rf /tmp/* || true
# find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
# find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;

# mkdir -p /var/tmp &&
#     chmod -R 1777 /var/tmp

# find /etc/yum.repos.d/ -maxdepth 1 -type f -name '*.repo' ! -name 'fedora.repo' ! -name 'fedora-updates.repo' ! -name 'fedora-updates-testing.repo' -exec rm -f {} +
# rm -rf /tmp/* || true
# dnf5 clean all

# ostree container commit

find /etc/yum.repos.d/ -maxdepth 1 -type f -name '*.repo' ! -name 'fedora.repo' ! -name 'fedora-updates.repo' ! -name 'fedora-updates-testing.repo' -exec rm -f {} +
rm -rf /tmp/* || true
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;
dnf5 clean all

mkdir -p /var/tmp &&
    chmod -R 1777 /var/tmp

echo "::endgroup::"
