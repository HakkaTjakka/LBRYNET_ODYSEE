#!/bin/bash

FILENAME_VIDEO=$1
FILENAME_AUDIO=$2
BASENAME="${FILENAME_VIDEO%.*}"

DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FILENAME_VIDEO")
echo "DURATION=$DURATION"

ffmpeg -y -hide_banner \
	-ss 0 -i "$FILENAME_VIDEO" \
	-ss 0 -i "$FILENAME_AUDIO" \
	-t $DURATION \
    -map 0:v:0 \
    -map 1:a:0 \
	-c:v h264_nvenc -pix_fmt yuv420p -c:a aac -ac 2 -b:a 128k -b:v 10M -async 1 $BASENAME.sound.mp4	
