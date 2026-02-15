#!/bin/bash

URL=$(echo "$1" | sed "s/x.com/twitter.com/")

COOKIES="cookies/youtube.com_cookies.txt"

bin/yt-dlp "$URL" --downloader aria2c -N 10 --cookies "$COOKIES" --restrict-filenames --trim-filenames 80 --merge-output-format mp4 --audio-format aac $2 $3
