#!/bin/bash

# ffmpeg -i input.mp4 -vf "select='gt(scene,0.4)',metadata=print:file=scenes.txt" -vsync vfr frame_%04d.png

# ffmpeg -framerate 0.2 -i frame_%04d.png -c:v h264_nvenc -pix_fmt yuv420p output.mp4

#ffmpeg -i "$1" -vframes 1 -q:v 1 -vf "select=eq(pict_type\,I)" -sseof -1 "$1.jpg"
#ffmpeg -i "$1" -vf "select='eq(n,0)+gte(t,prev_selected_t+10)',setpts=N/FRAME_RATE/TB" -vsync vfr -frame_pts 1 thumb_%d.jpg
#ffmpeg -sseof -1 -i "$1" -vframes 1 -q:v 1 -vf "select=eq(pict_type\,I)" last_keyframe.jpg


# ffmpeg -sseof -3 -i "$1" -update 1 -q:v 1 "$1.jpg"
# exit

# ffmpeg -i "$1" -ss 00:00:00 -vframes 1 "$1_start.jpg"
# exit

# ffmpeg -y -i "$1" -ss 555 -i "$2" \
# 	-filter_complex " \
# 	[0:a]volume=2.0[a0];[1:a]volume=1.0[a1];
# 	[a0][a1]amix=inputs=2[mixed]" \
# 	-map 0:v -map "[mixed]" -c:v copy -c:a aac -shortest "mixed_$1"

ffmpeg -y -i "$1" -ss 01:53:56 -i "$2"  \
	-filter_complex " \
	[0:a]volume=2.0[a0];[1:a]volume=1.5[a1];
	[a0][a1]amix=inputs=2:duration=shortest[mixed]" \
	-map 0:v:0 -c:v copy -map "[mixed]" -c:a aac -shortest "mixed_$1"
#	-map 0:v -map "[mixed]" -c:v h264_nvenc -pix_fmt yuv420p -c:a aac -shortest "mixed_$1"
exit

# #  -c:v h264_nvenc \
#   ffmpeg -i "$1" -ss 0 -i "$2" \
#    -c:a aac \
#    -map 0:v:0 -map 1:a:0 \
#    -c:v copy \
#    -shortest \
#    "remixed_$1"