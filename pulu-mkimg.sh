#!/bin/bash

# Check that build configuration exists
if [ ! -f config ]; then
    echo "Build configuration missing"
    exit 1
fi

# Set configuration variables
source config

# Set/check script variables
if [ -z "${IMG_NAME}" ];then
    echo "IMG_NAME not set"
    exit 1
fi

IMG_DATE="${IMG_DATE:-"$(date +%Y-%m-%d)"}"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${WORK_DIR:-"${BASE_DIR}/work/${IMG_DATE}-${IMG_NAME}"}"
DEPLOY_DIR=${DEPLOY_DIR:-"${BASE_DIR}/deploy"}
IMG_FILE="${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}-lite-qemu.zip"

# Build only a lite system by disabling stages 3-5
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES

sudo ./build.sh

# Copy kernel image to deploy directory
cp "${WORK_DIR}/stage2/rootfs/boot/kernel.img" "${DEPLOY_DIR}"

# Print image locations
echo "System image: ${IMG_FILE}"
echo "Kernel image: ${DEPLOY_DIR}/kernel.img"
