#!/bin/bash

COUNT=0

resolution_width=1920
resolution_height=1080
fps=60

# Set your video length here
video_length=8

COUNT=0

find . -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.mp4" \) | sort | while read -r line; do
  filename=${line:2}  # Remove './' from the filename
  echo "$filename"
  COUNT=$((COUNT + 1))
  COUNT_ZERO=$(printf '%04d\n' "$COUNT")

  # Extract file extension (case-insensitive)
  ext=$(echo "$filename" | awk -F . '{print tolower($NF)}')

  # Common settings for resolution and frame rate
  output_fps=$fps  # Ensure $fps is defined (e.g., 60)
  output_resolution="${resolution_width}x${resolution_height}"  # Ensure these are defined (e.g., 1920x1080)

  if [[ "$ext" == "jpg" || "$ext" == "jpeg" || "$ext" == "png" ]]; then
    # Handle images
    filter_complex="fps=$output_fps,scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,scale=-2:10*ih,zoompan=z='zoom+((on/10.0)^2.5)*0.000001':d=$(($fps * $video_length)):fps=$output_fps:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=$output_resolution,scale=-2:$resolution_height,reverse"
    ffmpeg -stats -hide_banner -threads 8 -nostdin -framerate "$fps" -i "$filename" \
      -filter_complex "$filter_complex" \
      -c:v h264_nvenc -t "$video_length" -pix_fmt yuv420p -b:v 10M -an "zoom${COUNT_ZERO}.mp4" 3>&1 1>&2- 2>&3- | grep -v "deprecated pixel format used"
  elif [[ "$ext" == "mp4" ]]; then
    # Get input video duration using ffprobe
    input_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$filename" 2>/dev/null)
    # Use input duration if less than $video_length, otherwise use $video_length
#    duration=$(echo "$input_duration < $video_length" | bc -l | xargs -I {} sh -c 'if [ {} -eq 1 ]; then echo $input_duration; else echo $video_length; fi')
    duration=$(awk -v input="$input_duration" -v target="$video_length" 'BEGIN {print (input < target && input > 0) ? input : target}')
echo DURATION=$duration
echo INPUT_DURATION=$input_duration
DDD=$(echo "$fps * $duration" | bc)
echo d=$DDD
DDD=1

    filter_complex="fps=fps=$output_fps"
    ffmpeg -stats -hide_banner -threads 8 -nostdin -i "$filename" \
      -filter_complex "$filter_complex" \
      -c:v h264_nvenc -c:a copy -t "$duration" -pix_fmt yuv420p -b:v 10M "zoom${COUNT_ZERO}.mp4" 3>&1 1>&2- 2>&3- | grep -v "deprecated pixel format used"
  fi
done