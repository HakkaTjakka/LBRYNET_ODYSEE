#!/bin/bash

round() {
  printf "%.${2}f" "${1}"
}

echo -------------------------------------------------------------------------- >> error.log

WANTED_LANGUAGE=$1

read -r FILENAME < filename.txt
echo "Filename: $FILENAME"
echo "Filename: $FILENAME" >> error.log
BASENAME="${FILENAME%.*}"
VAR=$(echo $BASENAME | sed 's/[][]/\\&/g' |  sed 's/ /\\ /g')
#VAR=$(echo $BASENAME | sed 's/ /\\ /g')
#VAR=$(echo $BASENAME | sed 's/[][]/\\&/g')


# convert .vtt to .srt. Can also be done by yt-dlp with --convert-subs srt but only after/when downloading. So when interrupted can be continued.

ONE="1.0"

echo "" > map.txt
echo " \\" > in.txt

#echo " -map 0:v:0 -map 0:a:0 \\" >> map.txt
MAP_COUNT=0
#if [ -f "in.txt" ]; then
# rm in.txt
#fi 

echo " -i \"$FILENAME\" \\" >> in.txt

#for line in $VAR.*.vtt

find . -maxdepth 1 -type f -name "$VAR.*.ass.double" -print0 | sort -z | while IFS= read -r -d '' line; # do
do
  LANGUAGE="${line%.*}"
  LANGUAGE="${LANGUAGE%.*}"
  LANGUAGE="${LANGUAGE##*.}"
  echo LANGUAGE=$LANGUAGE

  LANGUAGE_FULL=$LANGUAGE


    if [ "$LANGUAGE" == "af"        ];  then LANGUAGE_FULL="Afrikaans"    ; fi
    if [ "$LANGUAGE" == "ak"        ];  then LANGUAGE_FULL="Akan"     ; fi
    if [ "$LANGUAGE" == "sq"        ];  then LANGUAGE_FULL="Albanian"     ; fi
    if [ "$LANGUAGE" == "am"        ];  then LANGUAGE_FULL="Amharic"    ; fi
    if [ "$LANGUAGE" == "ar"        ];  then LANGUAGE_FULL="Arabic"     ; fi
    if [ "$LANGUAGE" == "hy"        ];  then LANGUAGE_FULL="Armenian"     ; fi
    if [ "$LANGUAGE" == "as"        ];  then LANGUAGE_FULL="Assamese"     ; fi
    if [ "$LANGUAGE" == "ay"        ];  then LANGUAGE_FULL="Aymara"     ; fi
    if [ "$LANGUAGE" == "az"        ];  then LANGUAGE_FULL="Azerbaijani"    ; fi
    if [ "$LANGUAGE" == "bn"        ];  then LANGUAGE_FULL="Bangla"     ; fi
    if [ "$LANGUAGE" == "eu"        ];  then LANGUAGE_FULL="Basque"     ; fi
    if [ "$LANGUAGE" == "be"        ];  then LANGUAGE_FULL="Belarusian"     ; fi
    if [ "$LANGUAGE" == "bho"       ];  then LANGUAGE_FULL="Bhojpuri"     ; fi
    if [ "$LANGUAGE" == "bs"        ];  then LANGUAGE_FULL="Bosnian"    ; fi
    if [ "$LANGUAGE" == "bg"        ];  then LANGUAGE_FULL="Bulgarian"    ; fi
    if [ "$LANGUAGE" == "my"        ];  then LANGUAGE_FULL="Burmese"    ; fi
    if [ "$LANGUAGE" == "ca"        ];  then LANGUAGE_FULL="Catalan"    ; fi
    if [ "$LANGUAGE" == "ceb"       ];  then LANGUAGE_FULL="Cebuano"    ; fi
    if [ "$LANGUAGE" == "zh-Hans"   ];  then LANGUAGE_FULL="Chinese (Simplified)"     ; fi
    if [ "$LANGUAGE" == "zh-Hant"   ];  then LANGUAGE_FULL="Chinese (Traditional)"    ; fi
    if [ "$LANGUAGE" == "co"        ];  then LANGUAGE_FULL="Corsican"     ; fi
    if [ "$LANGUAGE" == "hr"        ];  then LANGUAGE_FULL="Croatian"     ; fi
    if [ "$LANGUAGE" == "cs"        ];  then LANGUAGE_FULL="Czech"    ; fi
    if [ "$LANGUAGE" == "da"        ];  then LANGUAGE_FULL="Danish"     ; fi
    if [ "$LANGUAGE" == "dv"        ];  then LANGUAGE_FULL="Divehi"     ; fi
    if [ "$LANGUAGE" == "nl"        ];  then LANGUAGE_FULL="Dutch"    ; fi
    if [ "$LANGUAGE" == "en-orig"   ];  then LANGUAGE_FULL="English (Original)"     ; fi
    if [ "$LANGUAGE" == "en"        ];  then LANGUAGE_FULL="English"    ; fi
    if [ "$LANGUAGE" == "eo"        ];  then LANGUAGE_FULL="Esperanto"    ; fi
    if [ "$LANGUAGE" == "et"        ];  then LANGUAGE_FULL="Estonian"     ; fi
    if [ "$LANGUAGE" == "ee"        ];  then LANGUAGE_FULL="Ewe"    ; fi
    if [ "$LANGUAGE" == "fil"       ];  then LANGUAGE_FULL="Filipino"     ; fi
    if [ "$LANGUAGE" == "fi"        ];  then LANGUAGE_FULL="Finnish"    ; fi
    if [ "$LANGUAGE" == "fr"        ];  then LANGUAGE_FULL="French"     ; fi
    if [ "$LANGUAGE" == "gl"        ];  then LANGUAGE_FULL="Galician"     ; fi
    if [ "$LANGUAGE" == "lg"        ];  then LANGUAGE_FULL="Ganda"    ; fi
    if [ "$LANGUAGE" == "ka"        ];  then LANGUAGE_FULL="Georgian"     ; fi
    if [ "$LANGUAGE" == "de"        ];  then LANGUAGE_FULL="German"     ; fi
    if [ "$LANGUAGE" == "el"        ];  then LANGUAGE_FULL="Greek"    ; fi
    if [ "$LANGUAGE" == "gn"        ];  then LANGUAGE_FULL="Guarani"    ; fi
    if [ "$LANGUAGE" == "gu"        ];  then LANGUAGE_FULL="Gujarati"     ; fi
    if [ "$LANGUAGE" == "ht"        ];  then LANGUAGE_FULL="Haitian Creole"     ; fi
    if [ "$LANGUAGE" == "ha"        ];  then LANGUAGE_FULL="Hausa"    ; fi
    if [ "$LANGUAGE" == "haw"       ];  then LANGUAGE_FULL="Hawaiian"     ; fi
    if [ "$LANGUAGE" == "iw"        ];  then LANGUAGE_FULL="Hebrew"     ; fi
    if [ "$LANGUAGE" == "hi"        ];  then LANGUAGE_FULL="Hindi"    ; fi
    if [ "$LANGUAGE" == "hmn"       ];  then LANGUAGE_FULL="Hmong"    ; fi
    if [ "$LANGUAGE" == "hu"        ];  then LANGUAGE_FULL="Hungarian"    ; fi
    if [ "$LANGUAGE" == "is"        ];  then LANGUAGE_FULL="Icelandic"    ; fi
    if [ "$LANGUAGE" == "ig"        ];  then LANGUAGE_FULL="Igbo"     ; fi
    if [ "$LANGUAGE" == "id"        ];  then LANGUAGE_FULL="Indonesian"     ; fi
    if [ "$LANGUAGE" == "ga"        ];  then LANGUAGE_FULL="Irish"    ; fi
    if [ "$LANGUAGE" == "it"        ];  then LANGUAGE_FULL="Italian"    ; fi
    if [ "$LANGUAGE" == "ja"        ];  then LANGUAGE_FULL="Japanese"     ; fi
    if [ "$LANGUAGE" == "jv"        ];  then LANGUAGE_FULL="Javanese"     ; fi
    if [ "$LANGUAGE" == "kn"        ];  then LANGUAGE_FULL="Kannada"    ; fi
    if [ "$LANGUAGE" == "kk"        ];  then LANGUAGE_FULL="Kazakh"     ; fi
    if [ "$LANGUAGE" == "km"        ];  then LANGUAGE_FULL="Khmer"    ; fi
    if [ "$LANGUAGE" == "rw"        ];  then LANGUAGE_FULL="Kinyarwanda"    ; fi
    if [ "$LANGUAGE" == "ko"        ];  then LANGUAGE_FULL="Korean"     ; fi
    if [ "$LANGUAGE" == "kri"       ];  then LANGUAGE_FULL="Krio"     ; fi
    if [ "$LANGUAGE" == "ku"        ];  then LANGUAGE_FULL="Kurdish"    ; fi
    if [ "$LANGUAGE" == "ky"        ];  then LANGUAGE_FULL="Kyrgyz"     ; fi
    if [ "$LANGUAGE" == "lo"        ];  then LANGUAGE_FULL="Lao"    ; fi
    if [ "$LANGUAGE" == "la"        ];  then LANGUAGE_FULL="Latin"    ; fi
    if [ "$LANGUAGE" == "lv"        ];  then LANGUAGE_FULL="Latvian"    ; fi
    if [ "$LANGUAGE" == "ln"        ];  then LANGUAGE_FULL="Lingala"    ; fi
    if [ "$LANGUAGE" == "lt"        ];  then LANGUAGE_FULL="Lithuanian"     ; fi
    if [ "$LANGUAGE" == "lb"        ];  then LANGUAGE_FULL="Luxembourgish"    ; fi
    if [ "$LANGUAGE" == "mk"        ];  then LANGUAGE_FULL="Macedonian"     ; fi
    if [ "$LANGUAGE" == "mg"        ];  then LANGUAGE_FULL="Malagasy"     ; fi
    if [ "$LANGUAGE" == "ms"        ];  then LANGUAGE_FULL="Malay"    ; fi
    if [ "$LANGUAGE" == "ml"        ];  then LANGUAGE_FULL="Malayalam"    ; fi
    if [ "$LANGUAGE" == "mt"        ];  then LANGUAGE_FULL="Maltese"    ; fi
    if [ "$LANGUAGE" == "mi"        ];  then LANGUAGE_FULL="Māori"    ; fi
    if [ "$LANGUAGE" == "mr"        ];  then LANGUAGE_FULL="Marathi"    ; fi
    if [ "$LANGUAGE" == "mn"        ];  then LANGUAGE_FULL="Mongolian"    ; fi
    if [ "$LANGUAGE" == "ne"        ];  then LANGUAGE_FULL="Nepali"     ; fi
    if [ "$LANGUAGE" == "nso"       ];  then LANGUAGE_FULL="Northern Sotho"     ; fi
    if [ "$LANGUAGE" == "no"        ];  then LANGUAGE_FULL="Norwegian"    ; fi
    if [ "$LANGUAGE" == "ny"        ];  then LANGUAGE_FULL="Nyanja"     ; fi
    if [ "$LANGUAGE" == "or"        ];  then LANGUAGE_FULL="Odia"     ; fi
    if [ "$LANGUAGE" == "om"        ];  then LANGUAGE_FULL="Oromo"    ; fi
    if [ "$LANGUAGE" == "ps"        ];  then LANGUAGE_FULL="Pashto"     ; fi
    if [ "$LANGUAGE" == "fa"        ];  then LANGUAGE_FULL="Persian"    ; fi
    if [ "$LANGUAGE" == "pl"        ];  then LANGUAGE_FULL="Polish"     ; fi
    if [ "$LANGUAGE" == "pt"        ];  then LANGUAGE_FULL="Portuguese"     ; fi
    if [ "$LANGUAGE" == "pa"        ];  then LANGUAGE_FULL="Punjabi"    ; fi
    if [ "$LANGUAGE" == "qu"        ];  then LANGUAGE_FULL="Quechua"    ; fi
    if [ "$LANGUAGE" == "ro"        ];  then LANGUAGE_FULL="Romanian"     ; fi
    if [ "$LANGUAGE" == "ru"        ];  then LANGUAGE_FULL="Russian"    ; fi
    if [ "$LANGUAGE" == "sm"        ];  then LANGUAGE_FULL="Samoan"     ; fi
    if [ "$LANGUAGE" == "sa"        ];  then LANGUAGE_FULL="Sanskrit"     ; fi
    if [ "$LANGUAGE" == "gd"        ];  then LANGUAGE_FULL="Scottish Gaelic"    ; fi
    if [ "$LANGUAGE" == "sr"        ];  then LANGUAGE_FULL="Serbian"    ; fi
    if [ "$LANGUAGE" == "sn"        ];  then LANGUAGE_FULL="Shona"    ; fi
    if [ "$LANGUAGE" == "sd"        ];  then LANGUAGE_FULL="Sindhi"     ; fi
    if [ "$LANGUAGE" == "si"        ];  then LANGUAGE_FULL="Sinhala"    ; fi
    if [ "$LANGUAGE" == "sk"        ];  then LANGUAGE_FULL="Slovak"     ; fi
    if [ "$LANGUAGE" == "sl"        ];  then LANGUAGE_FULL="Slovenian"    ; fi
    if [ "$LANGUAGE" == "so"        ];  then LANGUAGE_FULL="Somali"     ; fi
    if [ "$LANGUAGE" == "st"        ];  then LANGUAGE_FULL="Southern Sotho"     ; fi
    if [ "$LANGUAGE" == "es"        ];  then LANGUAGE_FULL="Spanish"    ; fi
    if [ "$LANGUAGE" == "su"        ];  then LANGUAGE_FULL="Sundanese"    ; fi
    if [ "$LANGUAGE" == "sw"        ];  then LANGUAGE_FULL="Swahili"    ; fi
    if [ "$LANGUAGE" == "sv"        ];  then LANGUAGE_FULL="Swedish"    ; fi
    if [ "$LANGUAGE" == "tg"        ];  then LANGUAGE_FULL="Tajik"    ; fi
    if [ "$LANGUAGE" == "ta"        ];  then LANGUAGE_FULL="Tamil"    ; fi
    if [ "$LANGUAGE" == "tt"        ];  then LANGUAGE_FULL="Tatar"    ; fi
    if [ "$LANGUAGE" == "te"        ];  then LANGUAGE_FULL="Telugu"     ; fi
    if [ "$LANGUAGE" == "th"        ];  then LANGUAGE_FULL="Thai"     ; fi
    if [ "$LANGUAGE" == "ti"        ];  then LANGUAGE_FULL="Tigrinya"     ; fi
    if [ "$LANGUAGE" == "ts"        ];  then LANGUAGE_FULL="Tsonga"     ; fi
    if [ "$LANGUAGE" == "tr"        ];  then LANGUAGE_FULL="Turkish"    ; fi
    if [ "$LANGUAGE" == "tk"        ];  then LANGUAGE_FULL="Turkmen"    ; fi
    if [ "$LANGUAGE" == "uk"        ];  then LANGUAGE_FULL="Ukrainian"    ; fi
    if [ "$LANGUAGE" == "ur"        ];  then LANGUAGE_FULL="Urdu"     ; fi
    if [ "$LANGUAGE" == "ug"        ];  then LANGUAGE_FULL="Uyghur"     ; fi
    if [ "$LANGUAGE" == "uz"        ];  then LANGUAGE_FULL="Uzbek"    ; fi
    if [ "$LANGUAGE" == "vi"        ];  then LANGUAGE_FULL="Vietnamese"     ; fi
    if [ "$LANGUAGE" == "cy"        ];  then LANGUAGE_FULL="Welsh"    ; fi
    if [ "$LANGUAGE" == "fy"        ];  then LANGUAGE_FULL="Western Frisian"    ; fi
    if [ "$LANGUAGE" == "xh"        ];  then LANGUAGE_FULL="Xhosa"    ; fi
    if [ "$LANGUAGE" == "yi"        ];  then LANGUAGE_FULL="Yiddish"    ; fi
    if [ "$LANGUAGE" == "yo"        ];  then LANGUAGE_FULL="Yoruba"     ; fi
    if [ "$LANGUAGE" == "zu"        ];  then LANGUAGE_FULL="Zulu"     ; fi

    echo title=$LANGUAGE_FULL
    echo lang==$LANGUAGE


  MAP_COUNT_NEXT=$(echo "($MAP_COUNT+$ONE)"| bc -l);  
    MAP_COUNT_NEXT="${MAP_COUNT_NEXT%.*}"
  echo -n " -map $MAP_COUNT_NEXT" >> map.txt
  echo " -metadata:s:s:$MAP_COUNT language=$LANGUAGE -metadata:s:s:$MAP_COUNT title=\"$LANGUAGE_FULL\" \\" >> map.txt
  MAP_COUNT=$MAP_COUNT_NEXT

  echo " -i \"$BASENAME.$LANGUAGE.ass.double\" \\" >> in.txt
done
echo " " >> map.txt
MAP=$(cat map.txt)
IN=$(cat in.txt)
echo $IN
echo $MAP
# exit
# select wanted languages
#LANG="nl";     mv "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # Dutch nl
#LANG="nl";     cp "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # Dutch nl
#LANG="nl-vUrwgfI32b8";     cp "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # Dutch nl
#LANG="en";     mv "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # English en
#LANG="de";     mv "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # German  de
#LANG="fr";     mv "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # French  fr
#LANG="tr";     mv "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # Turkish tr
#LANG="ar";     mv "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # Arabic  ar
#LANG="zh-Hans";  mv "subs/$BASENAME/$LANG/$BASENAME.$LANG.srt.double" .  # Chinese zh-Hans

LANGUAGE=$WANTED_LANGUAGE
if [ ! -d "out" ]; then
  mkdir "out"
fi  
#echo $BASENAME
#exit
# if test -f "$BASENAME.xx.srt"; then
#   echo "sof/sof $BASENAME.xx.srt" >> COMMANDS.SH
#   sof/sof $BASENAME.xx.srt
# fi

for line in "$VAR.$LANGUAGE.ass.double"
#for line in $VAR.*.srt.double
#for line in $VAR.*.srt.single
do
  echo line=$line 
  LANGUAGE="${line%.*}"
  LANGUAGE="${LANGUAGE%.*}"
  LANGUAGE="${LANGUAGE##*.}"
  echo "Language: $LANGUAGE"

#echo "Subtitle fixed: $line"
#echo "Subtitle fixed: $line" >> error.log

  if test -f "out/$BASENAME.$LANGUAGE.mp4"; then
    echo "out/$BASENAME.$LANGUAGE.mp4 exists."
  else

    #FONTNAME="Simply Rounded Bold"
    #FONTNAME="AdobeCorpID-MyriadBl"
    # FONTNAME="Akkordeon-Ten"
    FONTNAME="BMWHelvetica-BlackCond"
    #FONTNAME="CHUTEROLK Free"


#    FONTSIZE="44"
#red        COLOR="000000FF"
#red        OUTLINE_COLOR="00FFFFFF"

#    COLOR="60900000"

#        COLOR="00FFFFFF"

#    COLOR="A0000000"
#    #OUTLINE_COLOR="00FFFFFF"
#    OUTLINE_COLOR="00FFFFFF"
    COLOR="00FFFFFF"
    OUTLINE_COLOR="00000000"
    FONTSIZE="26"
    OUTLINE="1.2"
    BACK_COLOR="80000000"
    BORDERSTYLE="0"
    SHADOW="1.2"
    ANGLE="0.0"
    ALIGNMENT="2"
#    ALIGNMENT="6"

#        FONTSIZE="26"
#        OUTLINE="1.0"
#        COLOR="0000FFFF"
#        OUTLINE_COLOR="00000000"
#   BACK_COLOR="A0000000"
#   BORDERSTYLE="0"
#   SHADOW="1.0"
#   ANGLE="0.0"
#        ALIGNMENT="2"

#        ALIGNMENT="10"
#        ALIGNMENT="6"

    FORCE_STYLE="'Fontname=$FONTNAME,FontSize=$FONTSIZE,Outline=$OUTLINE,PrimaryColour=&H$COLOR,OutlineColour=&H$OUTLINE_COLOR,BackColour=&H$BACK_COLOR,Shadow=$SHADOW,Angle=$ANGLE,BorderStyle=$BORDERSTYLE,Alignment=$ALIGNMENT'"
    SUBTITLES="subtitles=f='$line':force_style=$FORCE_STYLE"

    AUDIO_RATE=$(ffprobe -select_streams a:0 -v error -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$FILENAME")
    AUDIO_RATE=$(round ${AUDIO_RATE} 0)
    echo AUDIO_RATE=$AUDIO_RATE

    VIDEO_RATE=$(ffprobe -select_streams a:0 -v error -show_entries format=bit_rate -of default=noprint_wrappers=1:nokey=1 "$FILENAME")
    VIDEO_RATE=$(round ${VIDEO_RATE} 0)
    echo VIDEO_RATE=$VIDEO_RATE

#   exit

    PARMS_OUT="-strict -2 -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a aac -ac 2"
#   PARMS_OUT="-strict -2 -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a aac -ac 2 -b:a $AUDIO_RATE -b:v $VIDEO_RATE"
    PARMS_IN="-y -hide_banner -progress url -nostdin"

#   MAP="-map 0:v:0 -map 0:a:0"

#   IN="-i \"$FILENAME\""
    # ALIGNMENT="Alignment=2"
#
    # FILTER="-filter_complex \"[0:v]$SUBTITLES\""

#,pad=3840:2160:ow-iw:-1:color=red
#        SCALE="scale=1280:1440:force_original_aspect_ratio=decrease,pad=1920:1440:-1:0:color=0x800000"
    SCALE="scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:-1:-1:color=black"
#   SCALE="scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black"
    FILTER="-filter_complex \"[0:v]$SCALE,$SUBTITLES;[0:a]aresample=44100\""

    # FILTER="-filter_complex \"[0:v]$SCALE,tblend=all_expr='if(eq(mod(X,2),mod(Y,2)),A,B)',$SUBTITLES\""
    OUT="\"out/$BASENAME.$LANGUAGE.PART.mp4\""

    FFMPEG="ffmpeg"
    # echo $FORCE_STYLE

#   COMMAND="$FFMPEG $PARMS_IN $IN $MAP $FILTER $PARMS_OUT $OUT"

    COMMAND="$FFMPEG $PARMS_IN $IN$MAP$FILTER $PARMS_OUT $OUT"


#   COMMAND="ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style=$FORCE_STYLE\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style='Fontname=Simply Rounded Bold,FontSize=22,Outline=1'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="~/ffmpeg-n4.4-latest-linux64-gpl-4.4/bin/ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style='Fontname=Simply Rounded Bold,FontSize=20,Outline=1'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="~/ffmpeg-n4.4-latest-linux64-gpl-4.4/bin/ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style='Fontname=Simply Rounded Bold,FontSize=20,Outline=1'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="~/ffmpeg-n4.4-latest-linux64-gpl-4.4/bin/ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style='Fontname=Simply Rounded Bold,FontSize=24,Outline=2'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="~/ffmpeg-n4.4-latest-linux64-gpl-4.4/bin/ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style='Fontname=Simply Rounded Bold.ttf,FontSize=24,Outline=1'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="~/ffmpeg-n4.4-latest-linux64-gpl-4.4/bin/ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style='Fontname=Simply Rounded Bold,FontSize=24,Outline=1'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line':force_style='Fontname=Simply Rounded Bold,FontSize=24,Outline=1'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
#   COMMAND="ffmpeg -y -hide_banner -progress url -nostdin -i \"$FILENAME\" -map 0:v:0 -map 0:a:0 -strict -2 -filter_complex \"[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1:color=black,subtitles=f='$line'\" -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 -c:a copy \"out/$BASENAME.$LANGUAGE.PART.mp4\""
    echo "$COMMAND" >> COMMANDS.SH
    echo "$COMMAND" > command.sh
    chmod +x command.sh
    ./command.sh

    if [ "$LANGUAGE" == "af"        ];  then LANGUAGE_FULL="Afrikaans"    ; fi
    if [ "$LANGUAGE" == "ak"        ];  then LANGUAGE_FULL="Akan"     ; fi
    if [ "$LANGUAGE" == "sq"        ];  then LANGUAGE_FULL="Albanian"     ; fi
    if [ "$LANGUAGE" == "am"        ];  then LANGUAGE_FULL="Amharic"    ; fi
    if [ "$LANGUAGE" == "ar"        ];  then LANGUAGE_FULL="Arabic"     ; fi
    if [ "$LANGUAGE" == "hy"        ];  then LANGUAGE_FULL="Armenian"     ; fi
    if [ "$LANGUAGE" == "as"        ];  then LANGUAGE_FULL="Assamese"     ; fi
    if [ "$LANGUAGE" == "ay"        ];  then LANGUAGE_FULL="Aymara"     ; fi
    if [ "$LANGUAGE" == "az"        ];  then LANGUAGE_FULL="Azerbaijani"    ; fi
    if [ "$LANGUAGE" == "bn"        ];  then LANGUAGE_FULL="Bangla"     ; fi
    if [ "$LANGUAGE" == "eu"        ];  then LANGUAGE_FULL="Basque"     ; fi
    if [ "$LANGUAGE" == "be"        ];  then LANGUAGE_FULL="Belarusian"     ; fi
    if [ "$LANGUAGE" == "bho"       ];  then LANGUAGE_FULL="Bhojpuri"     ; fi
    if [ "$LANGUAGE" == "bs"        ];  then LANGUAGE_FULL="Bosnian"    ; fi
    if [ "$LANGUAGE" == "bg"        ];  then LANGUAGE_FULL="Bulgarian"    ; fi
    if [ "$LANGUAGE" == "my"        ];  then LANGUAGE_FULL="Burmese"    ; fi
    if [ "$LANGUAGE" == "ca"        ];  then LANGUAGE_FULL="Catalan"    ; fi
    if [ "$LANGUAGE" == "ceb"       ];  then LANGUAGE_FULL="Cebuano"    ; fi
    if [ "$LANGUAGE" == "zh-Hans"   ];  then LANGUAGE_FULL="Chinese (Simplified)"     ; fi
    if [ "$LANGUAGE" == "zh-Hant"   ];  then LANGUAGE_FULL="Chinese (Traditional)"    ; fi
    if [ "$LANGUAGE" == "co"        ];  then LANGUAGE_FULL="Corsican"     ; fi
    if [ "$LANGUAGE" == "hr"        ];  then LANGUAGE_FULL="Croatian"     ; fi
    if [ "$LANGUAGE" == "cs"        ];  then LANGUAGE_FULL="Czech"    ; fi
    if [ "$LANGUAGE" == "da"        ];  then LANGUAGE_FULL="Danish"     ; fi
    if [ "$LANGUAGE" == "dv"        ];  then LANGUAGE_FULL="Divehi"     ; fi
    if [ "$LANGUAGE" == "nl"        ];  then LANGUAGE_FULL="Dutch"    ; fi
    if [ "$LANGUAGE" == "en-orig"   ];  then LANGUAGE_FULL="English (Original)"     ; fi
    if [ "$LANGUAGE" == "en"        ];  then LANGUAGE_FULL="English"    ; fi
    if [ "$LANGUAGE" == "eo"        ];  then LANGUAGE_FULL="Esperanto"    ; fi
    if [ "$LANGUAGE" == "et"        ];  then LANGUAGE_FULL="Estonian"     ; fi
    if [ "$LANGUAGE" == "ee"        ];  then LANGUAGE_FULL="Ewe"    ; fi
    if [ "$LANGUAGE" == "fil"       ];  then LANGUAGE_FULL="Filipino"     ; fi
    if [ "$LANGUAGE" == "fi"        ];  then LANGUAGE_FULL="Finnish"    ; fi
    if [ "$LANGUAGE" == "fr"        ];  then LANGUAGE_FULL="French"     ; fi
    if [ "$LANGUAGE" == "gl"        ];  then LANGUAGE_FULL="Galician"     ; fi
    if [ "$LANGUAGE" == "lg"        ];  then LANGUAGE_FULL="Ganda"    ; fi
    if [ "$LANGUAGE" == "ka"        ];  then LANGUAGE_FULL="Georgian"     ; fi
    if [ "$LANGUAGE" == "de"        ];  then LANGUAGE_FULL="German"     ; fi
    if [ "$LANGUAGE" == "el"        ];  then LANGUAGE_FULL="Greek"    ; fi
    if [ "$LANGUAGE" == "gn"        ];  then LANGUAGE_FULL="Guarani"    ; fi
    if [ "$LANGUAGE" == "gu"        ];  then LANGUAGE_FULL="Gujarati"     ; fi
    if [ "$LANGUAGE" == "ht"        ];  then LANGUAGE_FULL="Haitian Creole"     ; fi
    if [ "$LANGUAGE" == "ha"        ];  then LANGUAGE_FULL="Hausa"    ; fi
    if [ "$LANGUAGE" == "haw"       ];  then LANGUAGE_FULL="Hawaiian"     ; fi
    if [ "$LANGUAGE" == "iw"        ];  then LANGUAGE_FULL="Hebrew"     ; fi
    if [ "$LANGUAGE" == "hi"        ];  then LANGUAGE_FULL="Hindi"    ; fi
    if [ "$LANGUAGE" == "hmn"       ];  then LANGUAGE_FULL="Hmong"    ; fi
    if [ "$LANGUAGE" == "hu"        ];  then LANGUAGE_FULL="Hungarian"    ; fi
    if [ "$LANGUAGE" == "is"        ];  then LANGUAGE_FULL="Icelandic"    ; fi
    if [ "$LANGUAGE" == "ig"        ];  then LANGUAGE_FULL="Igbo"     ; fi
    if [ "$LANGUAGE" == "id"        ];  then LANGUAGE_FULL="Indonesian"     ; fi
    if [ "$LANGUAGE" == "ga"        ];  then LANGUAGE_FULL="Irish"    ; fi
    if [ "$LANGUAGE" == "it"        ];  then LANGUAGE_FULL="Italian"    ; fi
    if [ "$LANGUAGE" == "ja"        ];  then LANGUAGE_FULL="Japanese"     ; fi
    if [ "$LANGUAGE" == "jv"        ];  then LANGUAGE_FULL="Javanese"     ; fi
    if [ "$LANGUAGE" == "kn"        ];  then LANGUAGE_FULL="Kannada"    ; fi
    if [ "$LANGUAGE" == "kk"        ];  then LANGUAGE_FULL="Kazakh"     ; fi
    if [ "$LANGUAGE" == "km"        ];  then LANGUAGE_FULL="Khmer"    ; fi
    if [ "$LANGUAGE" == "rw"        ];  then LANGUAGE_FULL="Kinyarwanda"    ; fi
    if [ "$LANGUAGE" == "ko"        ];  then LANGUAGE_FULL="Korean"     ; fi
    if [ "$LANGUAGE" == "kri"       ];  then LANGUAGE_FULL="Krio"     ; fi
    if [ "$LANGUAGE" == "ku"        ];  then LANGUAGE_FULL="Kurdish"    ; fi
    if [ "$LANGUAGE" == "ky"        ];  then LANGUAGE_FULL="Kyrgyz"     ; fi
    if [ "$LANGUAGE" == "lo"        ];  then LANGUAGE_FULL="Lao"    ; fi
    if [ "$LANGUAGE" == "la"        ];  then LANGUAGE_FULL="Latin"    ; fi
    if [ "$LANGUAGE" == "lv"        ];  then LANGUAGE_FULL="Latvian"    ; fi
    if [ "$LANGUAGE" == "ln"        ];  then LANGUAGE_FULL="Lingala"    ; fi
    if [ "$LANGUAGE" == "lt"        ];  then LANGUAGE_FULL="Lithuanian"     ; fi
    if [ "$LANGUAGE" == "lb"        ];  then LANGUAGE_FULL="Luxembourgish"    ; fi
    if [ "$LANGUAGE" == "mk"        ];  then LANGUAGE_FULL="Macedonian"     ; fi
    if [ "$LANGUAGE" == "mg"        ];  then LANGUAGE_FULL="Malagasy"     ; fi
    if [ "$LANGUAGE" == "ms"        ];  then LANGUAGE_FULL="Malay"    ; fi
    if [ "$LANGUAGE" == "ml"        ];  then LANGUAGE_FULL="Malayalam"    ; fi
    if [ "$LANGUAGE" == "mt"        ];  then LANGUAGE_FULL="Maltese"    ; fi
    if [ "$LANGUAGE" == "mi"        ];  then LANGUAGE_FULL="Māori"    ; fi
    if [ "$LANGUAGE" == "mr"        ];  then LANGUAGE_FULL="Marathi"    ; fi
    if [ "$LANGUAGE" == "mn"        ];  then LANGUAGE_FULL="Mongolian"    ; fi
    if [ "$LANGUAGE" == "ne"        ];  then LANGUAGE_FULL="Nepali"     ; fi
    if [ "$LANGUAGE" == "nso"       ];  then LANGUAGE_FULL="Northern Sotho"     ; fi
    if [ "$LANGUAGE" == "no"        ];  then LANGUAGE_FULL="Norwegian"    ; fi
    if [ "$LANGUAGE" == "ny"        ];  then LANGUAGE_FULL="Nyanja"     ; fi
    if [ "$LANGUAGE" == "or"        ];  then LANGUAGE_FULL="Odia"     ; fi
    if [ "$LANGUAGE" == "om"        ];  then LANGUAGE_FULL="Oromo"    ; fi
    if [ "$LANGUAGE" == "ps"        ];  then LANGUAGE_FULL="Pashto"     ; fi
    if [ "$LANGUAGE" == "fa"        ];  then LANGUAGE_FULL="Persian"    ; fi
    if [ "$LANGUAGE" == "pl"        ];  then LANGUAGE_FULL="Polish"     ; fi
    if [ "$LANGUAGE" == "pt"        ];  then LANGUAGE_FULL="Portuguese"     ; fi
    if [ "$LANGUAGE" == "pa"        ];  then LANGUAGE_FULL="Punjabi"    ; fi
    if [ "$LANGUAGE" == "qu"        ];  then LANGUAGE_FULL="Quechua"    ; fi
    if [ "$LANGUAGE" == "ro"        ];  then LANGUAGE_FULL="Romanian"     ; fi
    if [ "$LANGUAGE" == "ru"        ];  then LANGUAGE_FULL="Russian"    ; fi
    if [ "$LANGUAGE" == "sm"        ];  then LANGUAGE_FULL="Samoan"     ; fi
    if [ "$LANGUAGE" == "sa"        ];  then LANGUAGE_FULL="Sanskrit"     ; fi
    if [ "$LANGUAGE" == "gd"        ];  then LANGUAGE_FULL="Scottish Gaelic"    ; fi
    if [ "$LANGUAGE" == "sr"        ];  then LANGUAGE_FULL="Serbian"    ; fi
    if [ "$LANGUAGE" == "sn"        ];  then LANGUAGE_FULL="Shona"    ; fi
    if [ "$LANGUAGE" == "sd"        ];  then LANGUAGE_FULL="Sindhi"     ; fi
    if [ "$LANGUAGE" == "si"        ];  then LANGUAGE_FULL="Sinhala"    ; fi
    if [ "$LANGUAGE" == "sk"        ];  then LANGUAGE_FULL="Slovak"     ; fi
    if [ "$LANGUAGE" == "sl"        ];  then LANGUAGE_FULL="Slovenian"    ; fi
    if [ "$LANGUAGE" == "so"        ];  then LANGUAGE_FULL="Somali"     ; fi
    if [ "$LANGUAGE" == "st"        ];  then LANGUAGE_FULL="Southern Sotho"     ; fi
    if [ "$LANGUAGE" == "es"        ];  then LANGUAGE_FULL="Spanish"    ; fi
    if [ "$LANGUAGE" == "su"        ];  then LANGUAGE_FULL="Sundanese"    ; fi
    if [ "$LANGUAGE" == "sw"        ];  then LANGUAGE_FULL="Swahili"    ; fi
    if [ "$LANGUAGE" == "sv"        ];  then LANGUAGE_FULL="Swedish"    ; fi
    if [ "$LANGUAGE" == "tg"        ];  then LANGUAGE_FULL="Tajik"    ; fi
    if [ "$LANGUAGE" == "ta"        ];  then LANGUAGE_FULL="Tamil"    ; fi
    if [ "$LANGUAGE" == "tt"        ];  then LANGUAGE_FULL="Tatar"    ; fi
    if [ "$LANGUAGE" == "te"        ];  then LANGUAGE_FULL="Telugu"     ; fi
    if [ "$LANGUAGE" == "th"        ];  then LANGUAGE_FULL="Thai"     ; fi
    if [ "$LANGUAGE" == "ti"        ];  then LANGUAGE_FULL="Tigrinya"     ; fi
    if [ "$LANGUAGE" == "ts"        ];  then LANGUAGE_FULL="Tsonga"     ; fi
    if [ "$LANGUAGE" == "tr"        ];  then LANGUAGE_FULL="Turkish"    ; fi
    if [ "$LANGUAGE" == "tk"        ];  then LANGUAGE_FULL="Turkmen"    ; fi
    if [ "$LANGUAGE" == "uk"        ];  then LANGUAGE_FULL="Ukrainian"    ; fi
    if [ "$LANGUAGE" == "ur"        ];  then LANGUAGE_FULL="Urdu"     ; fi
    if [ "$LANGUAGE" == "ug"        ];  then LANGUAGE_FULL="Uyghur"     ; fi
    if [ "$LANGUAGE" == "uz"        ];  then LANGUAGE_FULL="Uzbek"    ; fi
    if [ "$LANGUAGE" == "vi"        ];  then LANGUAGE_FULL="Vietnamese"     ; fi
    if [ "$LANGUAGE" == "cy"        ];  then LANGUAGE_FULL="Welsh"    ; fi
    if [ "$LANGUAGE" == "fy"        ];  then LANGUAGE_FULL="Western Frisian"    ; fi
    if [ "$LANGUAGE" == "xh"        ];  then LANGUAGE_FULL="Xhosa"    ; fi
    if [ "$LANGUAGE" == "yi"        ];  then LANGUAGE_FULL="Yiddish"    ; fi
    if [ "$LANGUAGE" == "yo"        ];  then LANGUAGE_FULL="Yoruba"     ; fi
    if [ "$LANGUAGE" == "zu"        ];  then LANGUAGE_FULL="Zulu"     ; fi

    COMMAND="mv \"out/$BASENAME.$LANGUAGE.PART.mp4\" \"out/$BASENAME.$LANGUAGE_FULL.mp4\""
    echo "$COMMAND" >> COMMANDS.SH
    echo "$COMMAND" > command.sh
    chmod +x command.sh
    # burn *(&'r burn
    ./command.sh
  fi
done


