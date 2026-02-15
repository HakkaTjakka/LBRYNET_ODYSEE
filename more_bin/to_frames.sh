#!/bin/bash

# ffmpeg -i input.mp4 -vf "select='gt(scene,0.4)',metadata=print:file=scenes.txt" -vsync vfr frame_%04d.png

# ffmpeg -framerate 0.2 -i frame_%04d.png -c:v h264_nvenc -pix_fmt yuv420p output.mp4

#ffmpeg -i "$1" -vframes 1 -q:v 1 -vf "select=eq(pict_type\,I)" -sseof -1 "$1.jpg"
#ffmpeg -i "$1" -vf "select='eq(n,0)+gte(t,prev_selected_t+10)',setpts=N/FRAME_RATE/TB" -vsync vfr -frame_pts 1 thumb_%d.jpg
#ffmpeg -sseof -1 -i "$1" -vframes 1 -q:v 1 -vf "select=eq(pict_type\,I)" last_keyframe.jpg


ffmpeg -sseof -3 -i "$1" -update 1 -q:v 1 "$1.jpg"
exit

# ffmpeg -i "$1" -ss 00:00:00 -vframes 1 "$1_start.jpg"
# exit

# ffmpeg -i "$1" -ss 400 -i "$2" \
# 	-filter_complex " \
# 	[0:a]volume=1.0[a0];[1:a]volume=1.0[a1];
# 	[a0][a1]amix=inputs=2:duration=shortest[mixed]" \
# 	-map 0:v -map "[mixed]" -c:v copy -c:a aac -shortest "mixed_$1"


#ffmpeg -i "$1" -ss 850 -i "$2" \
# -c:v h264_nvenc \
# -c:a aac \
# -map 0:v:0 -map 1:a:0 \
# -shortest \
# output.mp4