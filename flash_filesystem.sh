#!/bin/bash

set -o xtrace

PROJECT_DIR=$(dirname $0)/../..

cd ${PROJECT_DIR}

PROJECT_NAME=$(cat .project_name)
[[ -z "${PROJECT_NAME}" ]] \
    && echo "File ../../.project_name not Found." \
    && echo "Keep project structure from https://github.com/adiog/embed-esp-project" \
    && exit 1

INO=$(find  -name "*.ino")
SOURCE_DIR=$(realpath $(dirname ${INO}))

DEFAULT_DEVICE=`ls -1 /dev/ttyUSB* | head -1`
DEVICE=${2:-${DEFAULT_DEVICE}}

ESP_SDK_PATH=./esp/sdk
TOOL_DIR=${ESP_SDK_PATH}/bin

BUILD_DIR=./build

mkdir -p ${BUILD_DIR}

export PATH=${TOOL_DIR}:$PATH

DEFAULT_SIZE=1028096
# you may try to reduce the filesystem size to speedup the flashing process
# EXPERIMENTAL_SIZE=65366

mkspiffs -c ${SOURCE_DIR}/data -p 256 -b 8192 -s ${DEFAULT_SIZE} ${BUILD_DIR}/FS.spiffs.bin
esptool -cd nodemcu -cb 115200 -cp ${DEVICE} -ca 0x300000 -cf ${BUILD_DIR}/FS.spiffs.bin

