#!/bin/sh

LD_SCRIPT_TEMPLATE=$1
BOOTLOADER_ELF=$2
CMAKE_CACHE_FILE=$3
TOOLCHAIN_PREFIX=$4

if [[ $# < 2 ]]; then
    echo "Usage: $0 <ld_script_template> <bootloader_elf> </path/to/CMakeCache.txt> [toolcahin-prefix]"
    exit 1
fi

BOOTLOADER_START=`${TOOLCHAIN_PREFIX}readelf -l $BOOTLOADER_ELF | grep -P "LOAD.*RWE" | awk '{print $3}'`
BOOTLOADER_SIZE=`${TOOLCHAIN_PREFIX}readelf -l $BOOTLOADER_ELF | grep -P "LOAD.*RWE" | awk '{print $6}'`
BOOTLOADER_END=`${TOOLCHAIN_PREFIX}readelf -l $BOOTLOADER_ELF | grep -P "LOAD.*RW " | awk '{print $3}'`

APP_START="$BOOTLOADER_START + $BOOTLOADER_SIZE + 8"
APP_SIZE="$BOOTLOADER_END - ($APP_START)"

HEADER_W1=`grep HEADER_W1 ${CMAKE_CACHE_FILE} | sed 's/HEADER_W1:.*=\(.*\)$/\1/'`
HEADER_W2=`grep HEADER_W2 ${CMAKE_CACHE_FILE} | sed 's/HEADER_W2:.*=\(.*\)$/\1/'`

sed -e "s/@APP_START@/$APP_START/"\
    -e "s/@APP_SIZE@/$APP_SIZE/"\
    -e "s/@HEADER_W1@/$HEADER_W1/"\
    -e "s/@HEADER_W2@/$HEADER_W2/"\
    $LD_SCRIPT_TEMPLATE
