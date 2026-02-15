#!/bin/bash

ffmpeg \
  -loop 1 -i "$1" -i "$2" \
  -filter_complex "fps=fps=1" \
  -map 0:v -map 1:a \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a aac -b:a 92k \
  -shortest -y "$2.mp4"
exit


#/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
#  -loop 1 -i hans.jpg -i hans.mp3 \
#  -filter_complex \
#"[0:v]scale=400:400:force_original_aspect_ratio=decrease,\
# pad=400:400:(ow-iw)/2:(oh-ih)/2:black,\
# zoompan=z='if(between(mod(on,30),26,29),zoom+0.028*(29-mod(on,30))/4,zoom*0.965)'\
#        :x='iw/2-(iw/zoom/2)+95*between(mod(on,30),26,29)*sin(on*1.2)'\
#        :y='ih/2-(ih/zoom/2)+95*between(mod(on,30),26,29)*cos(on*1.2)'\
#        :d=1:s=400x400:fps=60,\
# rotate=between(mod(on,30),26,29)*0.45*sin(on*2)*PI/180:ow=400:oh=400:c=black[v]" \
#  -map "[v]" -map 1:a \
#  -c:v h264_nvenc -preset p7 -cq 18 -b:v 0 \
#  -c:a aac -b:a 320k \
#  -shortest -y hans_PUMP_EN_DRAAI.mp4
#
round() {
  printf "%.${2}f" "${1}"
}

VIDEO="soros.mp4"
AUDIO="boem.mp3"
MASK="mask.png"
BACKGROUND="wierd_duck.jpg"
BG_VIDEO="dresden.mp4"
SCALE=1024
UPSCALE=1.2
UPSCALE=$(echo "$SCALE*$UPSCALE" | bc)
UPSCALE=$(round ${UPSCALE} 0)
UPSCALE=$(( UPSCALE & -2 )) 
MIDDLE=$(( SCALE / 2 ))
# DOWNSCALE=1.5
# DOWNSCALE=$(echo "$SCALE*$DOWNSCALE" | bc)
# DOWNSCALE=$(round ${DOWNSCALE} 0)

echo MIDDLE=$MIDDLE
echo UPSCALE=$UPSCALE
echo DOWNSCALE=$DOWNSCALE
#exit
read FPS      <<< $(ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate "$VIDEO")
read DURATION     <<< $(ffprobe -v error -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO")
read -d " " XX YY O P <<< $(ffprobe -v error -show_entries stream=width,height -of default=noprint_wrappers=1:nokey=1 "$VIDEO")

echo "FPS=$FPS"
echo "DURATION=$DURATION"
echo "SCALE=$XX:$YY"

## 
## # MIN=$(( XX < YY ? XX : YY ))
## # echo $MIN
## 
ffmpeg -y -i "$MASK" -filter_complex "scale=$SCALE:$SCALE" "SCALED_$MASK"
## ffmpeg -y -i "$BACKGROUND" -filter_complex "scale=$SCALE:$SCALE" "SCALED_$BACKGROUND"
## 

## ffmpeg -y -i "$BG_VIDEO" -filter_complex \
##    "crop='min($XX,$YY)': \
##    'min($XX,$YY)': \
##    '(in_w-min(in_w\,in_h))/2': \
##    '(in_h-min(in_w\,in_h))/2', scale=$SCALE:$SCALE" \
##      -c:v h264_nvenc -pix_fmt yuv420p \
##    "CROPPED_$BG_VIDEO"

## ffmpeg -y -i "$VIDEO" -filter_complex \
##   "crop='min($XX,$YY)': \
##   'min($XX,$YY)': \
##   '(in_w-min(in_w\,in_h))/2': \
##   '(in_h-min(in_w\,in_h))/2', scale=$SCALE:$SCALE" \
##     -c:v h264_nvenc -pix_fmt yuv420p \
##   "CROPPED_$VIDEO"


MASK="SCALED_$MASK"
BACKGROUND="SCALED_$BACKGROUND"
VIDEO="CROPPED_$VIDEO"
BG_VIDEO="CROPPED_$BG_VIDEO"

echo VIDEO="$VIDEO"
echo BACKGROUND="$BACKGROUND"
echo MASK="$MASK"

#  -i "$BACKGROUND"           \
# -loop 1 -i "$BACKGROUND" \
#  -stream_loop -1 -i "$BG_VIDEO" \
ffmpeg -y -hide_banner -progress url -nostdin \
  -i "$VIDEO"          \
  -loop 1 -i "$BACKGROUND" \
  -i "$MASK"                 \
  -t $DURATION \
  -filter_complex " \
    [2:v]alphaextract[alph]; \
    [1:v][alph]alphamerge[fg]; \
    [0:v]scale=$UPSCALE:$UPSCALE[vv];[vv]zoompan=z='if(between(mod(on,30),24,29),zoom+0.028*(29-mod(on,30))/4,zoom*0.965)'\
      :x='iw/2-(iw/zoom/2)+95*between(mod(on,30),24,29)*sin(on*1.2)'\
      :y='ih/2-(ih/zoom/2)+95*between(mod(on,30),24,29)*cos(on*1.2)'\
      :d=1:s=$UPSCALE"x"$UPSCALE:fps=$FPS, \
      rotate='t/0.8':ow=$SCALE:oh=$SCALE:c=black[v1];[v1]scale=$SCALE:$SCALE[v0]; \
    [v0][fg]overlay=0:0[v] \
  " \
  -map "[v]" -map 0:a \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a copy BLENDED.mp4

exit

  "[0:v]fps=fps=60,scale=720:720,\
  zoompan=z='if(between(mod(on,30),24,29),zoom+0.028*(29-mod(on,30))/4,zoom*0.965)'\
  :x='iw/2-(iw/zoom/2)+95*between(mod(on,30),24,29)*sin(on*1.2)'\
  :y='ih/2-(ih/zoom/2)+95*between(mod(on,30),24,29)*cos(on*1.2)'\
  :d=1:s=720x720:fps=60, \
  rotate=t:ow=720:oh=720:c=black,
  scale=720:720 \


ffmpeg -y -hide_banner -progress url -nostdin -i "$VIDEO" -i "$MASK" -i "$BACKGROUND" -filter_complex " \
[1:v]format=gray,geq='lum(X,Y)'[mask_alpha]; \
[0:v][mask_alpha]alphamerge[masked];         \
[2:v][masked]overlay=shortest=1             \
" \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a copy BLENDED.mp4
exit

ffmpeg -i "$VIDEO" -i "$MASK" -i "$BACKGROUND" -filter_complex "
[1:v]format=rgba,alphaextract,negate,format=rgba[alpha];
[0:v]format=rgba[video];                                
[video][alpha]alphamerge[masked];                       
[2:v][masked]overlay=shortest=1
" -c:a copy output.mp4

#ffmpeg -i "$VIDEO" -i "$MASK" -i "$BACKGROUND" -filter_complex "
#[1:v]format=rgba,alphaextract[alpha];      # extract alpha from mask
#[0:v]format=rgba[video];                   # ensure video has alpha
#[video][alpha]alphamerge[masked];          # apply alpha from mask
#[2:v][masked]overlay=shortest=1
#" -c:a copy output.mp4

exit

/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
  -stream_loop -1 -i "$VIDEO" \
  -i "$AUDIO" \
  -filter_complex \
  "[0:v]fps=fps=60,scale=720:720,\
  zoompan=z='if(between(mod(on,30),24,29),zoom+0.028*(29-mod(on,30))/4,zoom*0.965)'\
  :x='iw/2-(iw/zoom/2)+95*between(mod(on,30),24,29)*sin(on*1.2)'\
  :y='ih/2-(ih/zoom/2)+95*between(mod(on,30),24,29)*cos(on*1.2)'\
  :d=1:s=720x720:fps=60, \
  rotate=t:ow=720:oh=720:c=black,
  scale=720:720 \
  [v]" \
  -map "[v]" -map 1:a \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a aac -b:a 92k \
  -b:v 2000k \
  -shortest -y hans_FAKE_BASS_PUMP.mp4
exit

# zoompan=z='1.0+0.12*abs(sin(on/6))':\
# x='iw/2-(iw/zoom/2)+15*sin(on/2)':\
# y='ih/2-(ih/zoom/2)+15*cos(on/2)':\
# d=1:s=400x400:fps=60[v]" \

#ffmpeg -i hans.mp3 -af "astats=metadata=1:reset=1" -f null - 2> rms.log

#grep "RMS level dB" rms.log | awk '{print $7}' > rms_values.txt


exit

  # /home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
# -loop 1 -i hans.jpg -i hans.mp3 \
# -filter_complex \
# "[1:a]asplit=2[a_main][a_sc]; \
# [a_main][a_sc]sidechaincompress=threshold=0.001:ratio=20:attack=1:release=30,\
# lowpass=f=150,volume=20; \
# [0:v]scale=1920:1080:force_original_aspect_ratio=decrease,\
# pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,\
# zoompan=z='1.0+0.10*abs(sin(on/6))':\
# x='iw/2-(iw/zoom/2)+10*sin(on/2)':\
# y='ih/2-(ih/zoom/2)+10*cos(on/2)':\
# d=1:s=1920x1080:fps=60[v]" \
# -map "[v]" -map 1:a \
# -c:v h264_nvenc -pix_fmt yuv420p \
# -c:a aac -b:a 320k -shortest -y output.mp4

/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
-loop 1 -i hans.jpg -i hans.mp3 \
-filter_complex \
"[1:a]asplit=2[a_main][a_sc]; \
[a_main][a_sc]sidechaincompress=threshold=0.001:ratio=20:attack=1:release=30,\
lowpass=f=150,volume=20[bass]; \
[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,\
pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,\
zoompan=z='1.0+0.10*abs(sin(on/6))':\
x='iw/2-(iw/zoom/2)+10*sin(on/2)':\
y='ih/2-(ih/zoom/2)+10*cos(on/2)':\
d=1:s=1920x1080:fps=60[v]" \
-map "[v]" -map 1:a \
-c:v h264_nvenc -pix_fmt yuv420p \
-c:a aac -b:a 320k -shortest -y output.mp4
exit

/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
  -loop 1 -i hans.jpg -i hans.mp3 -filter_complex \
  "[1:a]sidechaincompress=threshold=0.001:ratio=20:attack=1:release=30, \
     lowpass=f=150,volume=20[bass]; \
  [0:v]zoompan=z='zoom+0.4*between(on,0.1,1)':d=1:s=1920x1080:fps=60, \
     format=yuv420p[v]" \
  -map "[v]" -map 1:a \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a aac -b:a 320k -shortest -y output.mp4

exit
/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
-loop 1 -i hans.jpg -i hans.mp3 \
-filter_complex \
"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,\
pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,\
zoompan=z='1.0+0.08*abs(sin(on/6))':\
x='iw/2-(iw/zoom/2)+8*sin(on/2)':\
y='ih/2-(ih/zoom/2)+8*cos(on/2)':\
d=1:s=1920x1080:fps=60[v]" \
-map "[v]" -map 1:a \
-c:v h264_nvenc -preset p7 -cq 18 -b:v 0 \
-c:a aac -b:a 320k -pix_fmt yuv420p \
-shortest -y hans_speaker_FIXED.mp4


## /home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
## -loop 1 -i hans.jpg -i hans.mp3 \
## -filter_complex \
## "[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,\
##  pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,\
##  zoompan=z='1.0+0.06*sin(2*PI*1.6*t)':\
##  x='iw/2-(iw/zoom/2)+8*sin(2*PI*12*t)':\
##  y='ih/2-(ih/zoom/2)+8*cos(2*PI*11*t)':\
##  d=1:s=1920x1080:fps=60[v]" \
## -map "[v]" -map 1:a \
## -c:v h264_nvenc -preset p7 -cq 18 -b:v 0 \
## -c:a aac -b:a 320k -pix_fmt yuv420p \
## -shortest -y hans_speaker_pump.mp4

exit

#/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
#  -loop 1 -i hans.jpg -i hans.mp3 \
#  -vf "zoompan=z='zoom+0.0015':d=25:s=400x400:fps=60" \
#  -c:v h264_nvenc -preset p7 -cq 19 \
#  -c:a copy -shortest -y hans_bass_speaker.mp4

#/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
#  -loop 1 -i hans.jpg -i hans.mp3 \
#  -vf "zoompan=z='zoom+0.002':d=30:s=400x400:fps=60 \
#       :x='iw/2-(iw/zoom/2)'\
#       :y='ih/2-(ih/zoom/2)'\
#       :s=400x400"\
#  -c:v h264_nvenc -preset p7 -cq 19 \
#  -c:a copy -shortest -y hans_bass_speaker.mp4

# /home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
#   -loop 1 -i hans.jpg -i hans.mp3 \
#   -filter_complex \
# "[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,\
# pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,\
# zoompan=z='1.0 + 0.9*pow(sin(2*PI*fract(t*5.5)),12)':\
# d=1:\
# x='iw/2-(iw/zoom/2) + 25*pow(sin(2*PI*fract(t*11)),8)':\
# y='ih/2-(ih/zoom/2) + 25*pow(sin(2*PI*fract(t*13)),8)':\
# s=1920x1080" \
#   -c:v h264_nvenc -preset p7 -cq 18 -b:v 0 \
#   -c:a copy -shortest -y hans_bass_speaker.mp4

# 1. Create the tiny command file (only once)
# cat > bass_zoom.cmd <<EOF
# ffout force=1;
# 0-999999 zoom 1.0 + 1.4*bass;
# EOF
# 
# # 2. The actual working ffmpeg command
# /home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
#  -loop 1 -i hans.jpg -i hans.mp3 \
#  -filter_complex \
# "[1:a]asplit=2[amain][aenv];\
# [aenv]compand=attacks=0:decays=0.03:points=-90/-90|-30/-20|-12/-8|0/-6,\
#       lowpass=f=180,volume=25,\
#       asendcmd=c='0-999999 bass volume',ametadata=mode=print:file=bass.txt[bass];\
# [0:v]scale=1920:1080:force_original_aspect_ratio=decrease,\
#      pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black,\
#      sendcmd=f=bass_zoom.cmd,zoompan=z='zoom + if(eq(zoom,1),0,0.001)':d=1\
#      :x='iw/2-(iw/zoom/2)+20*sin(t*50)*bass'\
#      :y='ih/2-(ih/zoom/2)+20*cos(t*50)*bass'\
#      :s=1920x1080[v];\
# [v]displace=edge=wrap[final]" \
#  -map "[final]" -map "[amain]" \
#  -c:v h264_nvenc -preset p7 -tune hq -cq 18 -b:v 0 \
#  -c:a aac -b:a 320k -shortest -y hans_bass_destroyer.mp4
#  exit

# /home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
#   -loop 1 -i hans.jpg -i hans.mp3 -filter_complex \
#   "[1:a]sidechaincompress=threshold=0.0001:ratio=20:attack=1:release=30, \
#      lowpass=f=150,volume=20[bass]; \
#   [0:v]zoompan=z='zoom+0.4*between(on,0.1,1)':d=1:s=1920x1080:fps=60, \
#      format=yuv420p[v]" \
#   -map "[v]" -map 1:a \
#   -c:v h264_nvenc -pix_fmt yuv420p \
#   -c:a aac -b:a 320k -shortest -y output.mp4
# exit
# /home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg \
#   -loop 1 -i hans.jpg \
#        -i hans.mp3 \
#        -filter_complex \
# "[1:a]showwaves=s=1920x200:mode=line:colors=white:scale=log:split_channels=off:gain=2.0,eq=brightness=0.5:contrast=5.0:gamma=0.5[basswave]; \
#  [0:v]scale=1920:980:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:black@0[img]; \
#  [img][basswave]overlay=0:880:shortest=1:alpha=0[vid]; \
#  [vid]zoompan=z='1.0 + 0.02*abs(sin(2*PI*t*0.5))':d=1:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1920x1080:fps=30[zoomed]" \
#        -map "[zoomed]" -map 1:a \
#        -c:v h264_nvenc -pix_fmt yuv420p \
#        -c:a aac -b:a 92k \
#        -shortest -y output.mp4
# exit


/home/pacman/movies/ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffmpeg  -loop 1 -i hans.jpg \
        -i hans.mp3 \
        -vf "zoompan=z='zoom + 0.003*on2bass(bass)'\
            :d=1:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):s=400x400" \
        -c:a aac -b:a 92k \
        -shortest -y \
        -c:v h264_nvenc -pix_fmt yuv420p \
        output.mp4
exit
# ffmpeg -y \
#   -stream_loop -1 \
#   -i boem.mp4 \
#   -i boem.mp3 \
#   -filter_complex "fps=fps=30" \
#   -c:v h264_nvenc -pix_fmt yuv420p \
#   -c:a aac \
#   -b:a 92k \
#   -b:v 2000k \
#   -shortest \
#   boem_out.mp4
#ffmpeg -y \
#  -loop 1 \
#  -i nederland1.png \
#  -i nederland1.mp3 \
#  -filter_complex "[0:v]fps=1[v]" \
#  -map "[v]" -map 1:a \
#  -c:v h264_nvenc -pix_fmt yuv420p \
#  -c:a aac -b:a 92k \
#  -b:v 300k \
#  -shortest \
#  nederland1.mp4
#ffmpeg -y \
#  -loop 1 \
#  -i nederland2.png \
#  -i nederland2.mp3 \
#  -filter_complex "[0:v]fps=1[v]" \
#  -map "[v]" -map 1:a \
#  -c:v h264_nvenc -pix_fmt yuv420p \
#  -c:a aac -b:a 92k \
#  -b:v 300k \
#  -shortest \
#  nederland2.mp4
exit
## ffmpeg \
##   -i ww2.mp4 \
##   -vf "setpts=PTS*(60000/1001)/60" \
##   -af "atempo=60/(60000/1001)" \
##   -r 60 \
##   -c:v h264_nvenc -pix_fmt yuv420p \
##   -c:a aac -b:a 320k \
##   ww2_60fps.mp4
## 
##   exit
#  -c:v libx264 -crf 0 -preset ultrafast \

# Dit script creëert een video van het afbeelding arno.jpg met 1 fps,
# resolutie behouden van de afbeelding, en audio van gek.mp3 gemixt in AAC-formaat.
# Output: arno_video.mp4 (je kunt dit aanpassen).
# Vereist: ffmpeg geïnstalleerd op Ubuntu (sudo apt install ffmpeg).

### ffmpeg -y \
###   -i retarted2.mp4 \
###   -i thug_life.mp3 \
###   -c:v h264_nvenc -pix_fmt yuv420p \
###   -map 0:v:0 \
###   -map 1:a:0 \
###   -c:a aac \
###   -b:a 192k \
###   -shortest \
###   retarded2_audio.mp4
### #exit
### 
### #  -filter_complex "fps=fps=1" \
### 
### echo "file 'retarded.mp4'" > filelist.txt
### echo "file 'retarded2_audio.mp4'" >> filelist.txt
### 
### ffmpeg -y -vsync 1 -safe 0 -f concat -i filelist.txt \
###  -c:v h264_nvenc -pix_fmt yuv420p \
###  -c:a aac \
###   -b:a 192k \
###   "combined.mp4"
### 
# -filter_complex "fps=fps=1" \

#  -stream_loop -1 \
## ffmpeg -y \
##   -loop 1 \
##   -i kut.jpg \
##   -i kut.mp3 \
##   -filter_complex "[0:v]fps=1[v]" \
##   -map "[v]" -map 1:a \
##   -c:v h264_nvenc -pix_fmt yuv420p \
##   -c:a aac -b:a 92k \
##   -b:v 300k \
##   -shortest \
##   kut.mp4
  exit
ffmpeg -y \
  -loop 1 \
  -i nummer2.jpg \
  -i nummer2.mp3 \
  -filter_complex "[0:v]fps=1[v]" \
  -map "[v]" -map 1:a \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a aac -b:a 92k \
  -b:v 300k \
  -shortest \
  nummer2.mp4
#ffmpeg -y \
#  -loop 1 \
#  -i war2.png \
#  -i nato2.mp3 \
#  -filter_complex "[0:v]fps=1[v]" \
#  -map "[v]" -map 1:a \
#  -c:v h264_nvenc -pix_fmt yuv420p \
#  -c:a aac -b:a 92k \
#  -b:v 300k \
#  -shortest \
#  war2.mp4

exit

## ffmpeg -y \
##   -stream_loop -1 \
##   -i fvd_in.mp4 \
##   -i fvd.mp3 \
##   -filter_complex "fps=fps=1" \
##   -c:v h264_nvenc -pix_fmt yuv420p \
##   -c:a aac \
##   -b:a 92k \
##   -b:v 300k \
##   -shortest \
##   fvd_out.mp4

ffmpeg -y \
  -loop 1 \
  -i cyber.png \
  -i cyber.mp3 \
  -filter_complex "fps=fps=60" \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a aac \
  -b:a 92k \
  -b:v 1000k \
  -shortest \
  cyber.mp4
## ffmpeg -y \
##  -loop 1 \
##  -i soldaten2.jpg \
##  -i soldaten2.mp3 \
##  -filter_complex "fps=fps=1" \
##  -c:v h264_nvenc -pix_fmt yuv420p \
##  -c:a aac \
##  -b:a 92k \
##  -b:v 300k \
##  -shortest \
##  soldaten2.mp4
exit
#ffmpeg -y \
#  -loop 1 \
#  -i ali.jpg \
#  -i hak2.mp3 \
#  -filter_complex "fps=fps=30" \
#  -c:v h264_nvenc -pix_fmt yuv420p \
#  -c:a aac \
#  -b:a 192k \
#  -shortest \
#  ali2.mp4
ffmpeg -y \
  -loop 1 \
  -i ali.jpg \
  -i hak3.mp3 \
  -filter_complex "fps=fps=30" \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a aac \
  -b:a 192k \
  -shortest \
  ali3.mp4
ffmpeg -y \
  -loop 1 \
  -i ali.jpg \
  -i hak4.mp3 \
  -filter_complex "fps=fps=30" \
  -c:v h264_nvenc -pix_fmt yuv420p \
  -c:a aac \
  -b:a 192k \
  -shortest \
  ali4.mp4



#echo "Video aangemaakt: scherm.mp4"

# ffmpeg -y \
#   -loop 1 \
#   -i breuk.jpg \
#   -i breuk.mp3 \
#   -filter_complex "fps=fps=1" \
#   -c:v h264_nvenc -pix_fmt yuv420p \
#   -c:a aac \
#   -b:a 192k \
#   -shortest \
#   breuk.mp4
# 
# echo "Video aangemaakt: breuk.mp4"
# 
# echo "file 'scherm.mp4'" > filelist.txt
# echo "file 'breuk.mp4'" >> filelist.txt
# 
# ffmpeg -y -vsync 1 -safe 0 -f concat -i filelist.txt \
#   -filter_complex "fps=fps=1" \
#   -c:v h264_nvenc -pix_fmt yuv420p "combined.mp4"
