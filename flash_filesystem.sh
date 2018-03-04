#!/bin/bash

set -o xtrace

PROJECT_DIR=$(dirname $0)/../..

cd ${PROJECT_DIR}

INO=$(find . -name "*.ino")
SOURCE_DIR=$(dirname ${INO})

DEFAULT_DEVICE=`ls -1 /dev/ttyUSB* | head -1`
DEVICE=${2:-${DEFAULT_DEVICE}}

ESP_SDK_PATH=../sdk
TOOL_DIR=${ESP_SDK_PATH}/bin

BUILD_DIR=./build

export PATH=${TOOL_DIR}:$PATH

# reducing the filesystem size to speedup the flashing process
DEFAULT_SIZE=1028096
EXPERIMENTAL_SIZE=65366

mkspiffs -c ${SOURCE_DIR}/data -p 256 -b 8192 -s ${EXPERIMENTAL_SIZE} ${BUILD_DIR}/FS.spiffs.bin
read
esptool -cd nodemcu -cb 115200 -cp ${DEVICE} -ca 0x300000 -cf ${BUILD_DIR}/FS.spiffs.bin

