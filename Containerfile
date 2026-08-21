# Allow build scripts to be referenced without being copied into the final image
ARG IMAGE_NAME="fedora-coreos"
ARG FEDORA_VERSION="44"
ARG BASE_IMAGE="quay.io/fedora/${IMAGE_NAME}"
# longterm-X.XX or coreos-stable
ARG KERNEL_FLAVOR="longterm-6.18"
ARG AKMODS_TAG="${KERNEL_FLAVOR}-${FEDORA_VERSION}"
FROM ghcr.io/ublue-os/akmods-zfs:${AKMODS_TAG} AS akmods-zfs

FROM scratch AS ctx
COPY / /
COPY system_files/ /system_files

FROM ${BASE_IMAGE}:${FEDORA_VERSION} AS base

COPY system_files/base /

ARG KERNEL_FLAVOR=${KERNEL_FLAVOR}

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/var \
    --mount=type=bind,from=akmods-zfs,src=/rpms,dst=/tmp/rpms/akmods-zfs \
    --mount=type=bind,from=akmods-zfs,src=/kernel-rpms,dst=/tmp/rpms/kernel \
    /ctx/build_files/build.sh

### LINTING
## Verify final image and contents are correct.
RUN ls -lha && bootc container lint
