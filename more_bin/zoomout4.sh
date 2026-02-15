#!/bin/bash

round() {
  printf "%.${2}f" "${1}"
}

# Set your desired resolution here
resolution_width=1024
resolution_height=1024
fps=60

# Set your video length here
video_length=10

COUNT=0

# Find files (images and videos)
find . -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.mp4" -o -name "*.webp" -o -name "*.gif" \) 
#exit

find . -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.mp4" -o -name "*.webp" -o -name "*.gif" \) | while read -r line; do
  filename=${line:2}  # Remove './' from the filename
  echo "$filename"
  COUNT=$((COUNT + 1))
  COUNT_ZERO=$(printf '%04d\n' "$COUNT")

  # Extract file extension (case-insensitive)
  ext=$(echo "$filename" | awk -F . '{print tolower($NF)}')

  # Common settings for resolution and frame rate
  output_fps=$fps  # Ensure $fps is defined (e.g., 60)
  output_resolution="${resolution_width}x${resolution_height}"  # Ensure these are defined (e.g., 1920x1080)

  # Get resolution using ffprobe
  resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$filename")
  
  # Extract width and height
  width=$(echo "$resolution" | cut -d'x' -f1)
  height=$(echo "$resolution" | cut -d'x' -f2)
  
  echo "Resolution: ${width}x${height}"
  echo "Width: $width pixels"
  echo "Height: $height pixels"
  resolution_width=$width
  resolution_height=$height
  output_resolution="${width}x${height}"  

# exit
    xoffset=$((512 * 5))
    yoffset=$((590 * 5))

  if [[ "$ext" == "webp" || "$ext" == "gif" || "$ext" == "jpg" || "$ext" == "jpeg" || "$ext" == "png" ]]; then
    # Handle images

    filter_complex="
      fps=$output_fps,
      scale=-2:5*ih,
      zoompan=z='zoom+((on/10.0)^2.5)*0.0000015':
      d=$(($fps * $video_length)):
      fps=$output_fps:
      x='($xoffset)-($xoffset)/zoom':
      y='($yoffset)-($yoffset)/zoom':
      s=$output_resolution,
      scale=-2:$resolution_height
      "
#      x='(iw/2+$xoffset)-((iw/2+$xoffset)/zoom)':
#      y='(ih/2+$yoffset)-((ih/2+$yoffset)/zoom)':
 #      ,reverse"

#    filter_complex="fps=$output_fps,scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,scale=-2:10*ih,zoompan=z='zoom+((on/10.0)^2.5)*0.000001':d=$(($fps * $video_length)):fps=$output_fps:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=$output_resolution,scale=-2:$resolution_height,reverse"
#-stats
    ffmpeg -hide_banner -threads 8 -nostdin -framerate "$fps" -i "$filename" \
      -filter_complex "$filter_complex" \
      -c:v h264_nvenc -t "$video_length" -pix_fmt yuv420p -b:v 10M -an "zap${COUNT_ZERO}.mp4" \
      3>&1 1>&2- 2>&3- | \
      grep -v "deprecated pixel format used" | \
      grep -v "Last message repeated"
      

  elif [[ "$ext" == "mp4" ]]; then


###     # Get input video duration using ffprobe
     input_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$filename" 2>/dev/null)
###     # Use the smaller of input_duration and video_length
### #    duration=$(awk -v input="$input_duration" -v target="$video_length" 'BEGIN {print (input < target && input > 0) ? input : target}')
    duration=$input_duration


###     filter_complex="
###       fps=$output_fps,
###       scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black"
### 
### 
###     ffmpeg -stats -hide_banner -threads 8 -nostdin -i "$filename" \
###       -filter_complex "$filter_complex" \
###       -c:v h264_nvenc -an \
###       -t "$duration" -pix_fmt yuv420p -b:v 10M "zoom${COUNT_ZERO}.mp4"


    video_length=$input_duration
    video_length=$(round ${video_length} 0)
    
#    read output_fps     <<< $(ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate "$filename")
#    fps=$output_fps

    # Get the frame rate as a fraction (e.g., 60/1)
    output_fps=$(ffprobe -v error -select_streams v:0 -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate "$filename")
    
    # Check if output_fps is a valid fraction
    if [[ ! $output_fps =~ ^[0-9]+/[0-9]+$ ]]; then
        echo "Error: Invalid frame rate format: $output_fps"
        exit 1
    fi
    
    # Extract numerator and denominator
    numerator=$(echo "$output_fps" | cut -d'/' -f1)
    denominator=$(echo "$output_fps" | cut -d'/' -f2)
    
    # Calculate frame rate as an integer using bc
    output_fps=$(echo "$numerator / $denominator" | bc)

    echo "Frame rate: $output_fps"
    echo fps=$output_fps
#exit
 ##     xoffset=550
 ##    yoffset=-50
 ##    filter_complex="
 ##      fps=$output_fps,
 ##      scale=-2:5*ih,
 ##      zoompan=z='zoom+((on/10.0)^2.5)*0.0000001':
 ##      d=$(($fps * $video_length)):
 ##      fps=$output_fps:
 ##      x='(iw/2+$xoffset)-((iw/2+$xoffset)/zoom)':
 ##      y='(ih/2+$yoffset)-((ih/2+$yoffset)/zoom)':
 ##      s=$output_resolution,
 ##      scale=-2:$resolution_height
 ##      "
#      ,reverse"

#    filter_complex="fps=$output_fps,scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,scale=-2:10*ih,zoompan=z='zoom+((on/10.0)^2.5)*0.000001':d=$(($fps * $video_length)):fps=$output_fps:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=$output_resolution,scale=-2:$resolution_height,reverse"

##    ffmpeg -stats -hide_banner -threads 8 -nostdin -i "$filename" \
##      -filter_complex "$filter_complex" \
##      -c:v h264_nvenc -an \
##      -t "$duration" -pix_fmt yuv420p -b:v 10M "zoom${COUNT_ZERO}.mp4"


    filter_complex="
      scale=-2:5*ih,
      zoompan=z='zoom+((on/10.0)^2.5)*0.000005':
      fps=$output_fps:
      d=1: 
      x='($xoffset)-($xoffset)/zoom':
      y='($yoffset)-($yoffset)/zoom':
      s=$output_resolution,
      scale=-2:$resolution_height"
#       x='iw/2-(iw/zoom/2)':
#       y='ih/2-(ih/zoom/2)':

#      d=$(($fps * $video_length)): 
# -stats
    ffmpeg -hide_banner -threads 8 -nostdin  -i "$filename" \
      -filter_complex "$filter_complex" \
      -r 60 -c:v h264_nvenc -an -t "$duration" -pix_fmt yuv420p -b:v 10M "zoom${COUNT_ZERO}.mp4"


#    ffmpeg -stats -hide_banner -threads 8 -nostdin -i "$filename" \
#      -filter_complex "$filter_complex" \
#      -r "$fps" -t "$video_length" -c:v h264_nvenc -pix_fmt yuv420p -b:v 10M -an "zap${COUNT_ZERO}.mp4"



### 
###     # Calculate total frames for zoom scaling
###     total_frames=$(awk -v dur="$duration" -v fps="$output_fps" 'BEGIN {print int(dur * fps)}')
### 
###     input_fps=$(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of default=noprint_wrappers=1:nokey=1 "$filename" 2>/dev/null | bc -l)
### #    input_fps=$(round ${input_fps} 3)
### 
### #    fps_ratio=$(awk -v input_fps="$input_fps" -v output_fps="$output_fps" 'BEGIN {print (input_fps > 0) ? input_fps / output_fps : 1}')
###     fps_ratio=$(echo "($input_fps / $output_fps)" | bc -l)
###     fps_ratio=$(round ${fps_ratio} 2)

# $ SPEED=0.5

#ATEMPO=$(echo "(1.0/($SPEED))"| bc -l)
#ATEMPO=$(round ${ATEMPO} 2)
#
#
#  [0:a]atempo=$ATEMPO,asetpts=PTS[a] \

    # Handle videos (no reverse, zoompan with dynamic zoom across all frames)

#    d=1: \
#    d=$(($fps * $duration)): \
###     echo total_frames=$total_frames
###     echo duration=$duration
###     echo input_duration=$input_duration
###     echo input_fps=$input_fps
###     echo fps_ratio=$fps_ratio
### #    read aaaa
###     read -r user_input < /dev/tty

  fi
done
#      -map "[v]" -map "[a]" \
