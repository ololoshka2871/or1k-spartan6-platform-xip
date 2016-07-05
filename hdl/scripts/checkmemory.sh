#!/bin/sh

MEM_TMP_FILE=$1
MEM_FILE=$2
HEX_IMAGE=$3


if [[ -f $MEM_FILE ]]; then
	MEM_FILE_DATE=`date -d "$(stat -c %y $MEM_FILE)" +%s`
else
	MEM_FILE_DATE=0
fi

IMAGE_DATE=`date -d "$(stat -c %y $HEX_IMAGE)" +%s`

if [[ "$IMAGE_DATE" > "$MEM_FILE_DATE" ]]; then 
	echo "File $HEX_IMAGE changed"
	cp $MEM_TMP_FILE $MEM_FILE
fi

