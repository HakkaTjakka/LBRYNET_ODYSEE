#!/bin/bash

# ──────────────────────────────────────────────────────────────
# CONFIG
# ──────────────────────────────────────────────────────────────

TRANSITION=1         # desired crossfade length in seconds
files=(*.mp4)          # all mp4 files in current folder
OUTPUT="crossfade.mp4"

# Better rounding function
# round() { printf "%.0f" "$1"; }
round() { awk -v num="$1" 'BEGIN { printf "%.6f", num }'; }  # Or just echo "$1" if awk supports direct print

# ──────────────────────────────────────────────────────────────
# Build inputs
# ──────────────────────────────────────────────────────────────

ffmpeg_cmd="ffmpeg -hide_banner -stats -threads 8"

echo ffmpeg_cmd

for f in "${files[@]}"; do
    ffmpeg_cmd+=" -i \"$f\""
    echo " -i \"$f\""
done

# ──────────────────────────────────────────────────────────────
# Build filter_complex - VIDEO + AUDIO
# ──────────────────────────────────────────────────────────────

filter_complex=""

# 1. Give friendly labels to all video & audio streams
echo "filter_complex="
for ((i=0; i<${#files[@]}; i++)); do
    filter_complex+="[${i}:v]fps=fps=30,scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:-1:-1:color=black,settb=AVTB,setsar=1[v${i}];"
#    filter_complex+="[${i}:v]settb=AVTB,setsar=1[v${i}];"
#    filter_complex+="[${i}:v]fps=fps=30[v${i}];"
#    filter_complex+="[${i}:v]fps=fps=30,settb=AVTB,setsar=1[v${i}];"
    echo "[${i}:v]fps=fps=30,scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:-1:-1:color=black,settb=AVTB,setsar=1[v${i}];"
done

# ─── VIDEO CHAIN ────────────────────────────────────────────────

cumulative_offset=0

# First pair
first_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${files[0]}" 2>/dev/null)
offset=$(awk -v d="$first_duration" -v t="$TRANSITION" 'BEGIN { printf "%.0f", (d-t) }')

filter_complex+="[v0][v1]xfade=transition=fade:duration=${TRANSITION}:offset=${offset}[v1out];"
echo "[v0][v1]xfade=transition=fade:duration=${TRANSITION}:offset=${offset}[v1out];"

cumulative_offset=$offset

# Middle → last pairs
for ((i=1; i<${#files[@]}-1; i++)); do
    dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${files[i]}" 2>/dev/null)

    offset=$(awk -v d="$dur" -v t="$TRANSITION" 'BEGIN { o=d-t; printf "%.0f", (o<1?1:o) }')
#    offset=$(awk -v d="$first_duration" -v t="$TRANSITION" 'BEGIN { print (d-t) }')

    cumulative_offset=$(awk -v c="$cumulative_offset" -v o="$offset" 'BEGIN { printf "%.0f", c+o }')
    if (( i == ${#files[@]}-2 )); then
        # last connection — no need to create new label
        filter_complex+="[v${i}out][v$((i+1))]xfade=transition=fade:duration=${TRANSITION}:offset=${cumulative_offset},format=yuv420p[video];"
        echo "[v${i}out][v$((i+1))]xfade=transition=fade:duration=${TRANSITION}:offset=${cumulative_offset},format=yuv420p[video];"
    else
        filter_complex+="[v${i}out][v$((i+1))]xfade=transition=fade:duration=${TRANSITION}:offset=${cumulative_offset}[v$((i+1))out];"
        echo "[v${i}out][v$((i+1))]xfade=transition=fade:duration=${TRANSITION}:offset=${cumulative_offset}[v$((i+1))out];"
    fi
done

# ─── AUDIO CHAIN ────────────────────────────────────────────────

cumulative_offset=0

# First pair
filter_complex+="[0:a][1:a]acrossfade=d=${TRANSITION}:c1=tri:c2=tri[a1out];"
echo "[0:a][1:a]acrossfade=d=${TRANSITION}:c1=tri:c2=tri[a1out];"

cumulative_offset=$offset   # reuse same first offset

for ((i=1; i<${#files[@]}-1; i++)); do
    dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${files[i]}" 2>/dev/null)
 
##     offset=$(awk -v d="$dur" -v t="$TRANSITION" 'BEGIN { o=d-t; print (o<1?1:o) }')
##     cumulative_offset=$(awk -v c="$cumulative_offset" -v o="$offset" 'BEGIN { print c+o }')

    offset=$(awk -v d="$dur" -v t="$TRANSITION" 'BEGIN { o=d-t; printf "%.0f", (o<1?1:o) }')
    cumulative_offset=$(awk -v c="$cumulative_offset" -v o="$offset" 'BEGIN { printf "%.0f", c+o }')

    if (( i == ${#files[@]}-2 )); then
        filter_complex+="[a${i}out][$(($i+1)):a]acrossfade=d=${TRANSITION}:c1=tri:c2=tri[audio];"
        echo "[a${i}out][$(($i+1)):a]acrossfade=d=${TRANSITION}:c1=tri:c2=tri[audio];"
    else
        filter_complex+="[a${i}out][$(($i+1)):a]acrossfade=d=${TRANSITION}:c1=tri:c2=tri[a$((i+1))out];"
        echo "[a${i}out][$(($i+1)):a]acrossfade=d=${TRANSITION}:c1=tri:c2=tri[a$((i+1))out];"
    fi
done

# ──────────────────────────────────────────────────────────────
# Final command
# ──────────────────────────────────────────────────────────────

ffmpeg_cmd+=" -filter_complex \"${filter_complex}\""
ffmpeg_cmd+=" -map \"[video]\" -map \"[audio]\""
#ffmpeg_cmd+=" -c:v h264_nvenc -preset p7 -rc vbr -b:v 4M -c:a aac -b:a 64k"
ffmpeg_cmd+=" -c:v h264_nvenc -pix_fmt yuv420p"
#ffmpeg_cmd+=" -strict -2 -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a aac -ac 2 -b:a 128k"
#ffmpeg_cmd+=" -strict -2 -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a aac -ac 2 -b:a 128k"
ffmpeg_cmd+=" -movflags +faststart \"$OUTPUT\""

echo "Executing:"
echo "$ffmpeg_cmd"
echo "$ffmpeg_cmd" > ffmpeg_cmd.sh
echo

eval "$ffmpeg_cmd"