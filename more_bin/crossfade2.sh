#!/bin/bash

round() {
  printf "%.${2}f" "${1}"
}

#Must value at least three .mp4 files in the directory

#videlength=10
transitionlength=6

#offset=$((videlength-transitionlength))

# Get a list of all MP4 files in the current directory
files=(*.mp4)

#echo Waiting 30 secs.
#sleep 30

# Create the ffmpeg command
#ffmpeg_command="ffmpeg -fflags +genpts -stats -hide_banner -threads 8"
ffmpeg_command="ffmpeg -fflags +genpts -stats -hide_banner -threads 8"



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

videlength=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 ${files[0]})
offset=$(echo "($videlength-$transitionlength)" | bc -l)
#offset=$((videlength-transitionlength))
offset=$(round ${offset} 0)
echo videlength  $videlength
echo offset      $offset

ffmpeg_command+="[0v][1v]xfade=transition=fade:duration=${transitionlength}:offset=${offset},setpts=N/60/TB[v1];"
totoffset=0
for ((i=1; i<${#files[@]}-1; i++)); do

  videlength=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 ${files[i]})

  offset=$(echo "($videlength-$transitionlength)" | bc -l)
  transitionlength=$(awk -v input="$offset" -v target="$transitionlength" 'BEGIN {print (input <= 1 ) ? 1 : 2}')
  transitionlength=$(awk -v input="$offset" -v target="$transitionlength" 'BEGIN {print (input <= 0 ) ? 0 : 2}')

  offset=$(awk -v input="$offset" 'BEGIN {print (input <= 1 ) ? 1 : input}')
  totoffset=$(echo "($totoffset + $offset)" | bc -l)

  offset=$(round ${offset} 0)
  totoffsetround=$(round ${totoffset} 0)

  echo $i ${files[i]}  videlength= $videlength  offset= $offset   totoffset=  $totoffset  totoffsetround= $totoffsetround transitionlength= $transitionlength

  if ((i == ${#files[@]}-2)); then 
    ffmpeg_command+="[v${i}][$(($i+1))v]xfade=transition=fade:duration=${transitionlength}:offset=$((${totoffsetround})),setpts=N/60/TB," #If last iteration don't add the [v$(($i+1))] to the end
  else
    ffmpeg_command+="[v${i}][$(($i+1))v]xfade=transition=fade:duration=${transitionlength}:offset=$((${totoffsetround})),setpts=N/60/TB[v$(($i+1))];"
  fi
done


#ffmpeg_command+="format=yuv420p[video]\" -b:v 10M -map \"[video]\" -c:v h264_nvenc -copyts -fps_mode cfr crossfade.mp4"
ffmpeg_command+="format=yuv420p[video]\" -map \"[video]\" -c:v h264_nvenc -copyts -fps_mode cfr crossfade.mp4"
#-fps_mode cfr
#ffmpeg_command+="format=yuv420p[video]\" -b:v 10M -map \"[video]\" -fps_mode cfr -c:v h264_nvenc crossfade.mp4"

# Execute the ffmpeg command
echo "$ffmpeg_command"
eval "$ffmpeg_command"
