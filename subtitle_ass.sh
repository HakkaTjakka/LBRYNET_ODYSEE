#!/bin/bash

LANGUAGE="unknown"
TRANSLATOR="en-us-0.42-gigaspeech"

echo -------------------------------------------------------------------------- >> error.log

echo Getting filename from URL: $1
echo Getting filename from URL: $1 >> error.log

#yt-dlp -i --merge-output-format mp4 --restrict-filenames --trim-filenames 40 --skip-unavailable-fragments --geo-bypass --get-filename "$*" -o "kut.mp4" > filename.txt
#yt-dlp -i --merge-output-format mp4 --restrict-filenames --trim-filenames 40 --skip-unavailable-fragments --geo-bypass --get-filename "$*" > filename.txt
#--trim-filenames 40
# FILENAMELENGTH=40
# 	--trim-filenames $FILENAMELENGTH \

if test -f "add_fix.txt"; then
	echo "Adding:"
	cat add_fix.txt
fi
yt-dlp -i "$1" \
	--merge-output-format mp4 \
	--restrict-filenames \
	--skip-unavailable-fragments \
	--geo-bypass \
	--get-filename \
	--no-playlist \
	--cookies cookies/twitter.com_cookies.txt > filename.txt
#	--cookies cookies/twitter.com_cookies.txt | sed 's/[][]//g' | sed 's/-//g' > filename.txt
#echo kut.mp4 > filename.txt
#echo "shit.mp4" > filename.txt
#exit
#yt-dlp -i --trim-filenames 40 --write-thumbnail --merge-output-format mp4 --restrict-filenames --skip-unavailable-fragments --geo-bypass --get-filename "$1" --cookies cookies/twitter.com_cookies.txt > filename.txt
#yt-dlp "$1" --restrict-filenames --list-thumbnails --cookies cookies/twitter.com_cookies.txt > thumbnails.txt

read -r FILENAME < filename.txt
echo "Filename: $FILENAME"
echo "Filename: $FILENAME" >> error.log

# FILENAME=$*
# echo $FILENAME > filename.txt

if test -f "from/$FILENAME"; then
	echo "Moving file from from/$FILENAME"
	mv "from/$FILENAME" .
fi

BASENAME="${FILENAME%.*}"
VAR=$(echo $BASENAME | sed 's/[][]/\\&/g')

if test -f "out/$BASENAME.$LANGUAGE.mp4"; then
	echo "out/$BASENAME.$LANGUAGE.mp4 exists."
else
	LANGUAGE="$3"
	LANGUAGE_FULL="$3"
	if [ ! "$2" == "" ]; then
					if [ "$LANGUAGE_FULL" == "Hungarian"  ];           then LANGUAGE="hu" ; fi

		if [ "$3" == "Hungarian"  ] || [ "$3" == "hu" ] ; then LANGUAGE="hu" ; LANGUAGE_FULL="Hungarian"  ; fi
		if [ "$3" == "Chinese"    ] || [ "$3" == "zh" ] ; then LANGUAGE="zh" ; LANGUAGE_FULL="Chinese"    ; fi
		if [ "$3" == "Korean"     ] || [ "$3" == "ko" ] ; then LANGUAGE="ko" ; LANGUAGE_FULL="Korean"     ; fi
		if [ "$3" == "Dutch"      ] || [ "$3" == "nl" ] ; then LANGUAGE="nl" ; LANGUAGE_FULL="Dutch"      ; fi
		if [ "$3" == "English"    ] || [ "$3" == "en" ] ; then LANGUAGE="en" ; LANGUAGE_FULL="English"    ; fi
		if [ "$3" == "French"     ] || [ "$3" == "fr" ] ; then LANGUAGE="fr" ; LANGUAGE_FULL="French"     ; fi
		if [ "$3" == "Italian"    ] || [ "$3" == "it" ] ; then LANGUAGE="it" ; LANGUAGE_FULL="Italian"    ; fi
		if [ "$3" == "German"     ] || [ "$3" == "de" ] ; then LANGUAGE="de" ; LANGUAGE_FULL="German"     ; fi
		if [ "$3" == "Turkish"    ] || [ "$3" == "tr" ] ; then LANGUAGE="tr" ; LANGUAGE_FULL="Turkish"    ; fi
		if [ "$3" == "Portuguese" ] || [ "$3" == "pt" ] ; then LANGUAGE="pt" ; LANGUAGE_FULL="Portuguese" ; fi
		if [ "$3" == "Russian"    ] || [ "$3" == "ru" ] ; then LANGUAGE="ru" ; LANGUAGE_FULL="Russian"    ; fi
		if [ "$3" == "Ukrainian"  ] || [ "$3" == "uk" ] ; then LANGUAGE="uk" ; LANGUAGE_FULL="Ukrainian"  ; fi
		if [ "$3" == "Arabic"     ] || [ "$3" == "ar" ] ; then LANGUAGE="ar" ; LANGUAGE_FULL="Arabic"     ; fi
		if [ "$3" == "Japanese"   ] || [ "$3" == "ja" ] ; then LANGUAGE="ja" ; LANGUAGE_FULL="Japanese"   ; fi
		if [ "$3" == "Urdu"       ] || [ "$3" == "ur" ] ; then LANGUAGE="ur" ; LANGUAGE_FULL="Urdu"       ; fi

		echo $LANGUAGE > language.txt
		echo $LANGUAGE_FULL > language_full.txt
		echo "LANGUAGE=$LANGUAGE"
		echo "LANGUAGE_FULL=$LANGUAGE_FULL"
	else
		echo "LANGUAGE=UNKNOWN"
	fi

#	COMMAND="yt-dlp --trim-filenames 40 --merge-output-format mp4 --restrict-filenames --trim-filenames 40 --default-search "ytsearch" --abort-on-error --no-mtime --write-auto-subs --download-archive ARCHIVE.TXT --skip-unavailable-fragments --write-thumbnail --geo-bypass --cookies cookies/twitter.com_cookies.txt "$*""
# --file-access-retries 10
#--no-playlist
#	yt-dlp --no-clean-info-json  --skip-download --write-info-json --default-search "ytsearch" --geo-bypass --cookies cookies/twitter.com_cookies.txt \"$1\" -o $FILENAME
#
# exit 0
#	COMMAND="yt-dlp --downloader aria2c -R infinite --console-title --socket-timeout 10  --extractor-retries 10 --fragment-retries 10 --retry-sleep 10 --merge-output-format mp4 --default-search "ytsearch" --abort-on-error --no-mtime --download-archive ARCHIVE.TXT --skip-unavailable-fragments --geo-bypass --cookies cookies/twitter.com_cookies.txt \"$1\" -o \"$FILENAME\""

#	COMMAND="yt-dlp --downloader aria2c --download-archive ARCHIVE.TXT -R 20 --write-info-json --merge-output-format mp4 \"$1\" -o \"$FILENAME\""

#	COMMAND="yt-dlp --downloader aria2c -R infinite --console-title --socket-timeout 10  --extractor-retries 10 --fragment-retries 10 --retry-sleep 10 --write-info-json --merge-output-format mp4 --default-search "ytsearch" --abort-on-error --no-mtime --skip-unavailable-fragments --geo-bypass --cookies cookies/twitter.com_cookies.txt \"$1\" -o \"$FILENAME\""

#	COMMAND="yt-dlp -N 10 --write-info-json -R 5 --merge-output-format mp4 \"$1\" -o \"$FILENAME\""

	COMMAND="yt-dlp --downloader aria2c --write-info-json -R 5 --merge-output-format mp4 \"$1\" -o \"$FILENAME\""

#	COMMAND="yt-dlp --downloader curl --write-info-json -R 5 --merge-output-format mp4 \"$1\" -o \"$FILENAME\""

#	COMMAND="yt-dlp --downloader curl -r 2M --write-info-json -R 5 --merge-output-format mp4 \"$1\" -o \"$FILENAME\""
#	COMMAND="yt-dlp --downloader wget --downloader-arg wget:-nv -r 2M --write-info-json -R 5 --merge-output-format mp4 \"$1\" -o \"$FILENAME\""
#	COMMAND="yt-dlp --downloader aria2c -r 2M --write-info-json -R 5 --merge-output-format mp4 \"$1\" -o \"$FILENAME\""

#	COMMAND="yt-dlp --downloader aria2c -R infinite --console-title --socket-timeout 10  --extractor-retries 10 --fragment-retries 10 --retry-sleep 10 --write-info-json --merge-output-format mp4 --default-search "ytsearch" --abort-on-error --no-mtime --download-archive ARCHIVE.TXT --skip-unavailable-fragments --geo-bypass --cookies cookies/twitter.com_cookies.txt \"$1\" -o \"$FILENAME\""
#	COMMAND="bin/yt-dlp --downloader aria2c -N 10 --write-info-json --merge-output-format mp4 --default-search "ytsearch" --abort-on-error --no-mtime --write-auto-subs --download-archive ARCHIVE.TXT --skip-unavailable-fragments --geo-bypass --cookies cookies/twitter.com_cookies.txt \"$1\" -o \"$FILENAME\""
#	COMMAND="bin/yt-dlp --downloader aria2c -N 10 --trim-filenames $FILENAMELENGTH --write-info-json --merge-output-format mp4 --default-search "ytsearch" --abort-on-error --no-mtime --write-auto-subs --download-archive ARCHIVE.TXT --skip-unavailable-fragments --geo-bypass --cookies cookies/twitter.com_cookies.txt \"$1\" -o \"$FILENAME\""
#	COMMAND="bin/yt-dlp --downloader aria2c -N 10 --trim-filenames $FILENAMELENGTH --write-info-json --merge-output-format mp4 --restrict-filenames --default-search "ytsearch" --abort-on-error --no-mtime --write-auto-subs --download-archive ARCHIVE.TXT --skip-unavailable-fragments --geo-bypass --cookies cookies/twitter.com_cookies.txt \"$1\" -o \"$FILENAME\""
#	COMMAND="yt-dlp --merge-output-format mp4 --restrict-filenames --trim-filenames 40 --default-search "ytsearch" --abort-on-error --no-mtime --write-auto-subs --download-archive ARCHIVE.TXT --skip-unavailable-fragments --write-thumbnail --geo-bypass "$*""
#	COMMAND="yt-dlp --merge-output-format mp4 --restrict-filenames --trim-filenames 40 --default-search "ytsearch" --abort-on-error --no-mtime --write-auto-subs --download-archive ARCHIVE.TXT --skip-unavailable-fragments --write-thumbnail --geo-bypass "$*" -o "kut.mp4""

	rm COMMANDS.SH
	echo "$COMMAND" >> COMMANDS.SH
	echo "$COMMAND" > command.sh
	chmod +x command.sh
	./command.sh

	echo "==================================================================================================================="
	echo "Description:"
	jq -r .description $BASENAME.info.json
	echo "========================="

	UPLOAD_DATE=$(jq -r .upload_date $BASENAME.info.json)
	UPLOAD_DATE=$(echo "$UPLOAD_DATE" | sed -E 's/(....)(..)(..)/\1\-\2\-\3/')
	echo "Upload_date: $UPLOAD_DATE"
	echo "========================="

	TITLE=$(jq -r .title $BASENAME.info.json)
	echo "Title: $TITLE"
	echo "==================================================================================================================="

	if test -f "$BASENAME.mkv"; then
		FILENAME="$BASENAME.mkv"
		echo "$BASENAME.mkv exists. Changing filename."
		echo "$FILENAME" > filename.txt
	fi

#	mv "$BASENAME.description" "$BASENAME.backup.description"
	echo "===================== End of Original Description =====================" > "$BASENAME.description"
	echo "Video Source: $1" >> "$BASENAME.description"
	echo "Translation(s) by Pacman Graphics: https://odysee.com/@PMG:5?view=channels"  >> "$BASENAME.description"
	echo "Speech Recognition & Translation (to English): Whisper, medium/turbo model" >> "$BASENAME.description"
	echo "Or https://github.com/soimort/translate-shell" >> "$BASENAME.description"
	echo "Subtitles Archive: https://drive.google.com/drive/folders/14RMVjdIla_OZ4TagWQUIDIWnb9dPcjtN" >> "$BASENAME.description"
	echo "👊 Buy me a Coffee: Bitcoin (BTC): 14eueBv7NuDGMqv4mBWLDFmU2g76h8vkYS" >> "$BASENAME.description"
	echo "==============================================================" >> "$BASENAME.description"
	echo "Other Channels 👉 https://odysee.com/@TheLastBattle:3?view=channels" >> "$BASENAME.description"
	echo "" >> "$BASENAME.description"
	echo "Featuring: (Click the 'Playlists' tab for selections)" >> "$BASENAME.description"
	echo "Europe: The Last Battle (2017) 👉 https://odysee.com/@TheLastBattle:3" >> "$BASENAME.description"
	echo "English Subtitles 👉 https://odysee.com/@English_Subtitles:b" >> "$BASENAME.description"
	echo "Actuele Video's Nederlands Ondertiteld. 👉 https://odysee.com/@Nederlands_Ondertiteld:0" >> "$BASENAME.description"
	echo "Unheard of 👉 https://odysee.com/@Unheard:5" >> "$BASENAME.description"
	echo "Fall of the Cabal 👉 https://odysee.com/@FalloftheCabal:0" >> "$BASENAME.description"
	echo "George Carlin - All My Stuff 👉 https://odysee.com/@AllMyStuff:2" >> "$BASENAME.description"
	echo "Vladimir Putin interview by Tucker Carlson 👉 https://odysee.com/@Putin_interview_by_Tucker_Carlson:f" >> "$BASENAME.description"
	echo "Pacman Graphics 👉 https://odysee.com/@PMG:5" >> "$BASENAME.description"
	echo "(🇬🇧EN) Ongehoord Nederland (English Subtitles) 👉 https://odysee.com/@Reserve3:c" >> "$BASENAME.description"
	echo "PDF DOCUMENTS 👉 https://odysee.com/@Reserve1:8" >> "$BASENAME.description"
	echo "==============================================================" >> "$BASENAME.description"
#	COMMAND="whisper \"$FILENAME\" --model medium --max_line_count 1 --highlight_words True --word_timestamps True $2 $3"
#	COMMAND="echo koekoek"
	COMMAND="whisper \"$FILENAME\" --model medium --max_line_count 1 --highlight_words True --word_timestamps True --no_speech_threshold 0.5 $2 $3"
#	COMMAND="whisper \"$FILENAME\" --task translate --model medium --no_speech_threshold 0.4 $2 $3"
	echo "$COMMAND" >> COMMANDS.SH
	echo "$COMMAND" > command.sh
	chmod +x command.sh
	#./command.sh
	ln=1

	script -c ./command.sh -f | while read -r line1; do
    	#echo "$line"  
    	BAR=$(printf "whisper: "$ln" = '$line1'" | tr -d '\r')
    	#echo $(printf "whisper: "$ln" = \"$line1\"" | tr -d '\r')
    	echo -n $BAR
    	printf "\r\n"
    	ln=$((ln+1))
    	#IFS=$' '
	    #echo "Unknown" > language.txt
    	echo $line1 | while read -r line_a line_b line_c; do
    		if [ "$line_a" = "Detected" ]; then  
	    		if [ "$line_b" = "language:" ]; then
	    			LANGUAGE=$(echo $line_c | tr -d '\r')
	    			echo $LANGUAGE > language.txt
	    			echo $LANGUAGE > language_full.txt
					read -r LANGUAGE_FULL < language.txt
    				echo "LANGUAGE="$line_c

					if [ "$LANGUAGE_FULL" == "Hungarian"  ];           then LANGUAGE="hu" ; fi
					if [ "$LANGUAGE_FULL" == "Chinese"    ];           then LANGUAGE="zh" ; fi
					if [ "$LANGUAGE_FULL" == "Dutch"      ];           then LANGUAGE="nl" ; fi
					if [ "$LANGUAGE_FULL" == "English"    ];           then LANGUAGE="en" ; fi
					if [ "$LANGUAGE_FULL" == "French"     ];           then LANGUAGE="fr" ; fi
					if [ "$LANGUAGE_FULL" == "Italian"    ];           then LANGUAGE="it" ; fi
					if [ "$LANGUAGE_FULL" == "German"     ];           then LANGUAGE="de" ; fi
					if [ "$LANGUAGE_FULL" == "Turkish"    ];           then LANGUAGE="tr" ; fi
					if [ "$LANGUAGE_FULL" == "Portuguese" ];           then LANGUAGE="pt" ; fi
					if [ "$LANGUAGE_FULL" == "Russian"    ];           then LANGUAGE="ru" ; fi
					if [ "$LANGUAGE_FULL" == "Ukrainian"  ];           then LANGUAGE="uk" ; fi
					if [ "$LANGUAGE_FULL" == "Arabic"     ];           then LANGUAGE="ar" ; fi
					if [ "$LANGUAGE_FULL" == "Japanese"   ];           then LANGUAGE="ja" ; fi
					if [ "$LANGUAGE_FULL" == "Urdu"       ];           then LANGUAGE="ur" ; fi
					echo $LANGUAGE > language.txt
    				printf "LANGUAGE=$LANGUAGE\r\n"
	    		fi
    		fi
    		#printf "line_a="$line_a"  line_b="$line_b"\r\n"
    	done
	done

#exit
#	echo English > language_full.txt
#	echo en > language.txt

	read -r LANGUAGE < language.txt
	read -r LANGUAGE_FULL < language_full.txt

#	COMMAND="sof/sof "$BASENAME.$LANGUAGE.srt""
	COMMAND="ffmpeg -y -hide_banner -i \"$BASENAME.srt\" \"$BASENAME.$LANGUAGE.ass\""

	echo "$COMMAND" >> COMMANDS.SH
	echo "$COMMAND" > command.sh
	chmod +x command.sh
	
	./command.sh

	cat "$BASENAME.$LANGUAGE.ass" | sed "s/\u1/c\&HA0FFA0\&/g" | sed "s/\u0/c\&HFFFFFF\&/g" > "$BASENAME.$LANGUAGE.ass.double"
#	cat "$BASENAME.$LANGUAGE.ass" | sed "s/\u1/c\&HFFFF\&/g" | sed "s/\u0/c\&HFFFFFF\&/g" > "$BASENAME.$LANGUAGE.ass.double"

#	burn_video_ass.sh $LANGUAGE

	mv "$BASENAME.single" "$BASENAME.$LANGUAGE.srt.double"
#	cp "$BASENAME.single" "$BASENAME.$LANGUAGE.srt"
#	sof/sof "$BASENAME.$LANGUAGE.srt"

	COMMAND="batch_translate.sh \"$BASENAME.$LANGUAGE.srt.double\""

	echo "$COMMAND" >> COMMANDS.SH
	echo "$COMMAND" > command.sh
	chmod +x command.sh
	./command.sh

	cp "$BASENAME.en.srt.double" "$BASENAME.en.srt"
	COMMAND="ffmpeg -y -hide_banner -i \"$BASENAME.en.srt\" \"$BASENAME.en.ass\"; mv \"$BASENAME.en.ass\" \"$BASENAME.en.ass.double\""
	echo "$COMMAND" >> COMMANDS.SH
	echo "$COMMAND" > command.sh
	chmod +x command.sh
#	./command.sh


	cp "$BASENAME.nl.srt.double" "$BASENAME.nl.srt"
	COMMAND="ffmpeg -y -hide_banner -i \"$BASENAME.nl.srt\" \"$BASENAME.nl.ass\"; mv \"$BASENAME.nl.ass\" \"$BASENAME.nl.ass.double\""
	echo "$COMMAND" >> COMMANDS.SH
	echo "$COMMAND" > command.sh
	chmod +x command.sh
#	./command.sh

## echo "Waiting for return"
## read a
	if [ "$LANGUAGE" == "en"  ]; then
		burn_video.sh nl
	    COMMAND="fix_to_odysee.sh \"$BASENAME.Dutch.mp4\" \"$BASENAME\" "
	    echo "$COMMAND" >> COMMANDS.SH
	    echo "$COMMAND" > command.sh
	    chmod +x command.sh
	    ./command.sh
		cp command3.sh "$BASENAME.command3.nl.sh"
	else
		if [ "$LANGUAGE" == "nl"  ]; then
			burn_video.sh en
			COMMAND="fix_english_to_odysee.sh \"$BASENAME.English.mp4\" \"$BASENAME\" "
		    echo "$COMMAND" >> COMMANDS.SH
		    echo "$COMMAND" > command.sh
		    chmod +x command.sh
		    ./command.sh
			cp command3.sh "$BASENAME.command3.en.sh"
		else
			burn_video.sh nl
		    COMMAND="fix_to_odysee.sh \"$BASENAME.Dutch.mp4\" \"$BASENAME\" "
		    echo "$COMMAND" >> COMMANDS.SH
		    echo "$COMMAND" > command.sh
		    chmod +x command.sh
		    ./command.sh
			cp command3.sh "$BASENAME.command3.nl.sh"

			burn_video.sh en
			COMMAND="fix_english_to_odysee.sh \"$BASENAME.English.mp4\" \"$BASENAME\" "
		    echo "$COMMAND" >> COMMANDS.SH
		    echo "$COMMAND" > command.sh
		    chmod +x command.sh
		    ./command.sh
			cp command3.sh "$BASENAME.command3.en.sh"
		fi
	fi

	burn_video_ass.sh $LANGUAGE

	if [ "$LANGUAGE" == "en"  ]; then
		COMMAND="fix_english_to_odysee.sh \"$BASENAME.English.mp4\" \"$BASENAME\" "
	    echo "$COMMAND" >> COMMANDS.SH
	    echo "$COMMAND" > command.sh
	    chmod +x command.sh
	    ./command.sh
		cp command3.sh "$BASENAME.command3.en.sh"
	else
	    COMMAND="fix_to_odysee.sh \"$BASENAME.Dutch.mp4\" \"$BASENAME\" "
	    echo "$COMMAND" >> COMMANDS.SH
	    echo "$COMMAND" > command.sh
	    chmod +x command.sh
	    ./command.sh
		cp command3.sh "$BASENAME.command3.nl.sh"
	fi

##    COMMAND="fix_to_odysee.sh \"$BASENAME.Dutch.mp4\" \"$BASENAME\" "
##    echo "$COMMAND" >> COMMANDS.SH
##    echo "$COMMAND" > command.sh
##    chmod +x command.sh
##    ./command.sh
##	cp command3.sh "$BASENAME.command3.nl.sh"
##
##	COMMAND="fix_english_to_odysee.sh \"$BASENAME.English.mp4\" \"$BASENAME\" "
##    echo "$COMMAND" >> COMMANDS.SH
##    echo "$COMMAND" > command.sh
##    chmod +x command.sh
##    ./command.sh
##	cp command3.sh "$BASENAME.command3.en.sh"

	mkdir "$BASENAME"
	find -maxdepth 1 -type f -name "$VAR*" -exec mv {} "$BASENAME" ';'
	#mv thumbnails.txt "$BASENAME"
	mv COMMANDS.SH "$BASENAME"
	mv command.sh "$BASENAME"
	mv command2.sh "$BASENAME"
	find -maxdepth 1 -type f -name "$BASENAME.command3.*.sh" -exec mv {} "$BASENAME" ';'
	mv typescript "$BASENAME"
	mv error.log "$BASENAME"
	cp filename.txt "$BASENAME"

exit
	echo "Waiting 16 minutes..."
	sleep 60
	echo "Waiting 15 minutes..."
	sleep 60
	echo "Waiting 14 minutes..."
	sleep 60
	echo "Waiting 13 minutes..."
	sleep 60
	echo "Waiting 12 minutes..."
	sleep 60
	echo "Waiting 11 minutes..."
	sleep 60
	echo "Waiting 10 minutes..."
	sleep 60
	echo "Waiting 9 minutes..."
	sleep 60
	echo "Waiting 8 minutes..."
	sleep 60
	echo "Waiting 7 minutes..."
	sleep 60
	echo "Waiting 6 minutes..."
	sleep 60
	echo "Waiting 5 minutes..."
	sleep 60
	echo "Waiting 4 minutes..."
	sleep 60
	echo "Waiting 3 minutes..."
	sleep 60
	echo "Waiting 2 minutes..."
	sleep 60
	echo "Waiting 1 minutes..."
	sleep 60
fi
