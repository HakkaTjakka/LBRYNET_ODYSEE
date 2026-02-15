#!/bin/bash

#Must value at least three .mp4 files in the directory

videlength=10
transitionlength=2

offset=$((videlength-transitionlength))

# Get a list of all MP4 files in the current directory
files=(*.mp4)

# Create the ffmpeg command
ffmpeg_command="ffmpeg -vsync 0"

# Iterate over the files and append input arguments to the ffmpeg command
for ((i=0; i<${#files[@]}; i++)); do
  ffmpeg_command+=" -i ${files[i]}"
  echo ${files[i]}
done

# Add the filter_complex argument to the ffmpeg command
ffmpeg_command+=" -filter_complex \""

for ((i=0; i<${#files[@]}; i++)); do
  ffmpeg_command+="[${i}:v]settb=AVTB[${i}v];"
done

ffmpeg_command+="[0v][1v]xfade=transition=fade:duration=${transitionlength}:offset=${offset}[v1];"

for ((i=1; i<${#files[@]}-1; i++)); do
  if ((i == ${#files[@]}-2)); then 
    ffmpeg_command+="[v${i}][$(($i+1))v]xfade=transition=fade:duration=${transitionlength}:offset=$((${offset}*(i+1)))," #If last iteration don't add the [v$(($i+1))] to the end
  else
    ffmpeg_command+="[v${i}][$(($i+1))v]xfade=transition=fade:duration=${transitionlength}:offset=$((${offset}*(i+1)))[v$(($i+1))];"
  fi
done


ffmpeg_command+="format=yuv420p[video]\" -b:v 3M -map \"[video]\" -c:v h264_nvenc crossfade.mp4"

# Execute the ffmpeg command
echo "$ffmpeg_command"
eval "$ffmpeg_command"
