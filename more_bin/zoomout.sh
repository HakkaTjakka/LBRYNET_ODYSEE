#!/bin/bash

#Make sure files end in .jpg and there is no spaces in the file names

# Set your desired resolution here
resolution_width=1920
resolution_height=1080
fps=60

# Set your video length here
video_length=10

COUNT=0

# ffmpeg -loop 1 -i input.jpg -c:v libx264 -t 10 -pix_fmt yuv420p 
#z='if(gte(zoom,1.5),1.5,2.0-(on*0.001))' \
#z='if(gte(zoom,1.5),1.5,zoom+0.001)' \
#z='if(gte(zoom,1.5),1.5,2.0-(on*0.001))' \
#z='if(gte(zoom,520),520,zoom+(on^3)*0.0000001)' \
# -loglevel error

find . -maxdepth 1 -name '*.jpg' | while read line; do
  echo ${line:2}
  COUNT=$(echo "($COUNT+1)"| bc -l);
  COUNT_ZERO=$(printf '%04d\n' "$COUNT")
  ffmpeg -stats -hide_banner -threads 8 -nostdin -framerate $fps -i "${line:2}" \
  -filter_complex \
  "scale=-2:10*ih:force_original_aspect_ratio=decrease,pad=19200:10800:-1:-1:color=black, \
  zoompan= \
  z='zoom+(((on/10.0)^2.5)/1000)*0.00003' \
  :d=$(($fps * $video_length)) \
  :fps=$fps \
  :x='iw/2-(iw/zoom/2)' \
  :y='ih/2-(ih/zoom/2)' \
  :s=${resolution_width}x${resolution_height}, \
  scale=-2:$resolution_height, \
  reverse" \
  -c:v h264_nvenc -t $video_length -pix_fmt yuv420p -b:v 10M "zoom"${COUNT_ZERO}.mp4 3>&1 1>&2- 2>&3- | grep -v "deprecated pixel format used"
#  -c:v h264_nvenc -t $video_length -pix_fmt yuv420p ${line:2}.mp4
#  reverse" \

#  echo "Press Enter for Next"
#  read aaa < /dev/tty
done

wait
echo "All done"
