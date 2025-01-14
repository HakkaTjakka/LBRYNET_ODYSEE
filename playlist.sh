#yt-dlp  --restrict-filenames "https://youtube.com/playlist?list=PL1kjtlmf25BXwGNj02M_zD_DbE2xhdHqY" --write-info-json --skip-download 

#yt-dlp  --restrict-filenames "$1" --write-info-json --skip-download 
#https://www.youtube.com/watch?v=fLiUlpm3Vro&list=UULFsXoGRbga9bP1YpWNiwiZIQ&ab_channel=DeGuldenMiddenweg
#yt-dlp  --yes-playlist --flat-playlist --restrict-filenames "https://rumble.com/c/THEPEOPLESVOICE/videos" --write-info-json --skip-download 

#yt-dlp  --restrict-filenames "https://rumble.com/c/THEPEOPLESVOICE/videos?page=3" --write-info-json --skip-download 
#https://openrss.org/rumble.com/russellbrand
#exit

#find . -maxdepth 1 -type f -name "*.info.json" -print0 | sort -z | while IFS= read -r -d '' line; # do

#https://odysee.com/@English_Subtitles:b/Random-English-Subs:8?lid=8c0c9f52009ba9718fbe929e3a2a8c1207253af4

doall() {
	rm json.list
	rm json.url.list
	rm list.json.sh
	rm download.list
	rm download.sh
	find . -maxdepth 1 -type f -name "*.info.json" -print0 | sort -z | while IFS= read -r -d '' line;
	do
	#	echo $line
	#	BASENAME="${FILENAME%.*}"
	#	VAR=$(echo $BASENAME | sed 's/[][]/\\&/g' |  sed 's/ /\\ /g')
		l2=$(../bin/get_json.sh "$line")
		echo $l2
		echo $l2 >> json.list
#		sleep 5
	done
}

flop() {
	l2=$(get_json.sh "$1")
	echo $l2
	echo $l2 >> json.list
}

flip() {
#		--downloader aria2c -N 10 \
	../bin/yt-dlp \
		--restrict-filenames "$1" \
		--write-info-json \
		--skip-download \
		--yes-playlist \
		--sleep-requests 5 \
		--retry-sleep 5 \


#	--sleep-requests 1	
#	flop "$1"
}
#flip "https://www.youtube.com/playlist?list=PL1D42C1B674EFBCBA"



mkdir cws
cd cws
# flip "https://odysee.com/@CafeWeltschmerz:f?view=content"
 doall
# 
sort -r json.url.list > json.url.sort
sort --key=6 -r list.json.sh > list.sorted.sh

sort --key=2 -r download.list | sed "s/$/ --language nl\n/" | sed "s/ - url: /\nsa /"  > download.sh

#flip "https://odysee.com/$/playlist/35cb275384176e88b4afc72ea02eb81db2933148"
#flip "https://www.youtube.com/@RealCandaceO/videos"
# flip "https://npo.nl/start/serie/ongehoord-nieuws/seizoen-2/ongehoord-nieuws_120"
# flip "https://www.youtube.com/@OngehoordNederlandTV/videos"
# exit
