#!/usr/bin/env bash
# =============================================================================
#   Images → individual MP4 clips → crossfade with accumulating offset
# =============================================================================

# ================= CONFIG =================
img_duration=6          # desired display time per image (seconds)
transition=1            # crossfade duration (seconds)
fps=60
output_file="slideshow_crossfade.mp4"
temp_dir="./temp_clips"
codec=(-c:v h264_nvenc -preset p5 -rc vbr -cq 24)  # fast NVIDIA; change to libx264 if needed

# ==========================================

mkdir -p "$temp_dir" || exit 1

# Get sorted images
mapfile -t images < <(ls -1 *.jpg *.jpeg *.png 2>/dev/null | sort)

(( ${#images[@]} < 2 )) && { echo "Need ≥2 images!"; exit 1; }

echo "Found ${#images[@]} images:"
printf '  %s\n' "${images[@]}"
echo

# ── Phase 1: Image → fixed-length MP4 ───────────────────────────────────────
echo "Phase 1: Creating ${img_duration}s MP4 clips..."
echo "--------------------------------------------"

intermediate=()
for i in "${!images[@]}"; do
    src="${images[i]}"
    dest="${temp_dir}/clip_${i}.mp4"

    printf "  %2d  %-45s → %s\n" "$i" "$src" "${dest##*/}"

    ffmpeg -y -hide_banner -loglevel error \
        -loop 1 -i "$src" \
        -t "$img_duration" \
        -r "$fps" -vf "fps=$fps,format=yuv420p" \
        "${codec[@]}" \
        "$dest"

    intermediate+=("$dest")
done

echo -e "\nAll clips ready.\n"

# ── Phase 2: Crossfade with ACCUMULATING offset ─────────────────────────────
echo "Phase 2: Crossfading clips..."
echo "--------------------------------------------"

# Get real duration of first clip (should be very close to img_duration)
first_dur=$(ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "${intermediate[0]}" | awk '{printf "%.3f",$1}')

offset_per_step=$(awk -v d="$first_dur" -v t="$transition" 'BEGIN {printf "%.3f", d-t}')

echo "Clip duration ≈ ${first_dur}s   →   offset per transition = ${offset_per_step}s"

filter="[0:v]setpts=PTS-STARTPTS,setsar=1[v0];"

accum=0
for ((i=1; i<${#intermediate[@]}; i++)); do
    accum=$(awk -v a="$accum" -v o="$offset_per_step" 'BEGIN {printf "%.3f", a+o}')

    label_in="v$((i-1))"
    label_out="v$i"

    if (( i == ${#intermediate[@]}-1 )); then
        filter+="[${label_in}][${i}:v]xfade=transition=fade:duration=${transition}:offset=${accum},format=yuv420p[video];"
    else
        filter+="[${label_in}][${i}:v]xfade=transition=fade:duration=${transition}:offset=${accum}[${label_out}];"
    fi
done

# Build command
cmd=(ffmpeg -y -hide_banner)
for f in "${intermediate[@]}"; do cmd+=(-i "$f"); done

cmd+=(
    -filter_complex "$filter"
    -map "[video]"
    -r "$fps"
    "${codec[@]}"
    -pix_fmt yuv420p
    -movflags +faststart
    "$output_file"
)

echo "Running final command..."
printf '  %q' "${cmd[@]}"
echo -e "\n\n"

time "${cmd[@]}"

echo -e "\nDone!\nOutput: $output_file"
echo "Temp clips: $temp_dir/   (delete when done)"