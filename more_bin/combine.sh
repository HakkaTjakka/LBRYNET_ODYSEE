#!/bin/bash

FILENAME=$*
BASENAME="${FILENAME%.*}"

# if [ -f list.txt ]; then
#     rm list.txt
# fi
# 
# #ls $1
# #exit
# 
# for f in $(ls $1)
# do
#   	echo "Processing $f file..."
# 	echo "file '$f'" >> list.txt
# done

# ffmpeg -i "$FILENAME" -c:v h264_nvenc -pix_fmt yuv420p -preset slow file1.mp4
# ffmpeg -i "file1.mp4" -vf reverse -af areverse -c:v h264_nvenc -pix_fmt yuv420p -preset slow file2.mp4

rm filelist.txt
find . -maxdepth 1 -type f -name "$FILENAME" -print0 | sort -z | while IFS= read -r -d '' line; # do
do
	echo "file '$line'">> filelist.txt
	echo "file '$line'"
done

# echo "file 'file1.mp4'" > list.txt
# echo "file 'file2.mp4'" >> list.txt

##     -filter_complex " \
##     [0:a]aresample=44100[a];
##     " \
##     -map "[a]" \
##### ffmpeg -y -vsync 1 -safe 0 -f concat -i filelist.txt \
#####      -filter_complex " \
#####      [0:a]aresample=44100[a];
#####      " \
#####      -map "[a]" \
#####     -map "v:0" \
#####     -c:v h264_nvenc -profile:v high -pix_fmt yuv420p "combined.mp4"

#	-filter_complex "fps=fps=1" \

#     -filter_complex " \
#     [0:a]aresample=44100[a];[0:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:-1:-1:color=black[v]
#     " \
#     -map "[a]" \
#     -map "[v]" \
#	-c:a aac -ac 2 \
#	-b:v 128k \

# ffmpeg -y -vsync 0 -safe 0 -f concat -i filelist.txt \
#     -c:v h264_nvenc -pix_fmt yuv420p "combined.mp4"

# ffmpeg -y -vsync 1 -safe 0 -f concat -i filelist.txt \
#     -c:v h264_nvenc -profile:v high -pix_fmt yuv420p "combined.mp4"

ffmpeg -y -safe 0 -f concat -i filelist.txt \
    -c:v h264_nvenc "combined.mp4"

#	-filter_complex "fps=fps=60" \

## ffmpeg -y -vsync 1 -safe 0 -f concat -i filelist.txt \
##     -filter_complex " \
##     [0:a]aresample=44100[a];
##     " \
##     -map "[a]" \
##     -map "v:0" \
##     -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -c:a aac -ac 2 "combined.mp4"



#	-c copy combined.mp4

#    -filter_complex " \
#     [0:a]aresample=44100[a0];
#     " \
#     -map "[a]" \

# ffmpeg -y -safe 0 -f concat -i filelist.txt -c copy -scodec copy combined.mp4
# ffmpeg -f concat -i files.lst -c copy -scodec copy output.mp4


#ffmpeg -y -i kut.mp4 -itsoffset 00:00:03 -i kut.aac -map 0:0 -map 1:0 -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -preset slow out.mp4

