#!/bin/bash

upload() {

LANGUAGE="${FILENAME%.*}"
LANGUAGE="${LANGUAGE##*.}"
#LANGUAGE="${FILENAME##*.}"

echo LANGUAGE=$LANGUAGE

FILENAME="/home/pacman/movies/out/$FILENAME"

THUMBNAIL_URL="$THUMBNAIL"

CHANNEL_ID="0f39e5c18b119190fe35ff5b10e5c5955cc387bb"
# CHANNEL_ID="b0a87e02bbc7397ed2b84f08bf0da5d4f309d1f4" english
# CHANNEL_ID="c10491c11bf087350305fda5aab3b68ae3672b88"
# CHANNEL_ID="5a2e06b836f46dcd906ec2b637015b1dc45e0439"
# CHANNEL_ID="fe7851f3d3c5e8de401ec7943cd67ef3fd6efb9e" Nederlands_Ondertiteld
# CHANNEL_ID="f09c1ff6e402fdff707afd56b71f43c0f968c00f"
# CHANNEL_ID="f09c1ff6e402fdff707afd56b71f43c0f968c00f"

BID_AMT="0.00011"

COMMAND='lbrynet publish \
--name="'${NAME}'" \
--title='${TITLE}' \
--description='${DESCRIPTION}'
--file_path="'${FILENAME}'" \
--tags="Nederlands" \
--tags="Ondertiteld" \
--thumbnail_url="'${THUMBNAIL_URL}'" \
--channel_id="'${CHANNEL_ID}'" \
--bid="'${BID_AMT}'"'

echo "$COMMAND" >> COMMANDS.SH

echo "STR=$'\n\n'" > command3.sh
echo -n "$COMMAND" >> command3.sh 

chmod +x command3.sh

echo UPLOADING LANGUAGE=$LANGUAGE
#exit
return
#./command3.sh

echo UPLOADED LANGUAGE=$LANGUAGE
}


#echo "====================================="

# TITLE=$(jq -r .title "$1")
#TITLE=$(echo -n $TITLE | sed "s|\"|\\\\\\\"|g"  )
#TITLE="\"(🇳🇱NL) "$TITLE"\""
#echo "====================================="

#WEBPAGE_URL=$(jq -r .webpage_url "$1")

### echo "title=        $TITLE"
### echo "webpage_url=  $WEBPAGE_URL"

# STR=$'\n'
# DESCRIPTION=$(jq -r .description "$1")
# DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s|Show more |\\n|g"  )
# DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s| Show less||g"  )
# DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s|\"|\\\\\\\"|g"  )
# #DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s|$|\"\"\$STR\"\"\\\|g"  )
# #DESCRIPTION="\""$DESCRIPTION""$STR"\" "
# DESCRIPTION="\""$DESCRIPTION"\" "
# echo "Description=$DESCRIPTION"

#echo "====================================="

FILENAME="$1"
BASENAME="${FILENAME%.*}"
#VAR=$(echo $BASENAME | sed 's/[][]/\\&/g' |  sed 's/ /\\ /g')
#NAME="${FILENAME%.*}"

### echo "Filename=     $FILENAME"
FILENAME=$(echo $FILENAME | sed 's/[][]/\\&/g' |  sed 's/ /\\ /g')
#NAME=$(echo $NAME | sed 's/\[//g' | sed 's/\]//g')
### echo "Filename=     $FILENAME"

TITLE=$(jq --raw-output .title "$1")

#RELEASE_DATE=$(jq -r .release_date "$1")
#echo "Release_date= $RELEASE_DATE - Link=$WEBPAGE_URL"

#STRING=$(jq -r .release_date,.webpage_url "$1" | sort -z | while IFS= read -r -d ' ' item; do; echo $item; done;)

#RELEASE_DATE=$(jq --raw-output .release_date "$1")

UPLOAD_DATE=$(jq --raw-output .upload_date "$1")
UPLOAD_DATE=$(echo "$UPLOAD_DATE" | sed -E 's/(....)(..)(..)/\1\-\2\-\3/')

#UPLOAD_DATE=$(printf '%c8s\n' "$UPLOAD_DATE")
#echo '20220416124334' | sed -E 's/(....)(..)(..)(..)(..)(..)/\1\/\2\/\3 \4:\5:\6/'

WEBPAGE_URL=$(jq --raw-output .webpage_url "$1")

DURATION_STRING=$(jq --raw-output .duration_string "$1")
DURATION_STRING=$(printf '%8s\n' "$DURATION_STRING")

DURATION=$(jq --raw-output .duration "$1")
DURATION=$(printf '%6s\n' "$DURATION")

#if [ ! "$RELEASE_DATE" == "null"        ]; then
if [ ! "$UPLOAD_DATE" == "null"        ]; then
	echo "date: $UPLOAD_DATE - title: $TITLE"
	echo "date: $UPLOAD_DATE - url: $WEBPAGE_URL - length: $DURATION_STRING	($DURATION)"
#	echo "date: $UPLOAD_DATE - title: $TITLE" >> json.url.list
#	echo "date: $UPLOAD_DATE - url: $WEBPAGE_URL" >> json.url.list
	echo "date: $UPLOAD_DATE - url: $WEBPAGE_URL - title: $TITLE" >> json.url.list

	echo "#date: $UPLOAD_DATE - length: $DURATION_STRING - title: \"$TITLE\" - url: \"$WEBPAGE_URL\"" >> download.list

#	echo "date: $RELEASE_DATE - url: $WEBPAGE_URL - length: $DURATION_STRING	($DURATION)"
#	echo "date: $RELEASE_DATE - url: $WEBPAGE_URL - length: "$(printf '%8s' "$DURATION_STRING")"	($DURATION)"
	echo -e "sa \"$WEBPAGE_URL\" --language nl # $UPLOAD_DATE - $DURATION_STRING - $TITLE" >> list.json.sh
fi
#fi

#printf '..%7s..' 'hello'

#echo -e "\n"

#find . -maxdepth 1 -type f -name "*.info.json" -print0 | sort -z | while IFS= read -r -d '' line;

#echo -e "\n"
#echo $STRING

#echo "====================================="
#echo -e "\n"
#upload
