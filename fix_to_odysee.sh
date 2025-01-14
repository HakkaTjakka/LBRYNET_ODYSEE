#!/bin/bash

upload() {
	
	#FILENAME="$1"
	LANGUAGE="${FILENAME%.*}"
	LANGUAGE="${LANGUAGE##*.}"
	#LANGUAGE="${FILENAME##*.}"
	
	echo LANGUAGE=$LANGUAGE
	
	FILENAME="/home/pacman/movies/out/$FILENAME"
	
	THUMBNAIL_URL="$THUMBNAIL"
	
	
	#CHANNEL_ID="c10491c11bf087350305fda5aab3b68ae3672b88"
	CHANNEL_ID="0f39e5c18b119190fe35ff5b10e5c5955cc387bb"
	# CHANNEL_ID="b0a87e02bbc7397ed2b84f08bf0da5d4f309d1f4" english
	#            	5a2e06b836f46dcd906ec2b637015b1dc45e0439
	#				fe7851f3d3c5e8de401ec7943cd67ef3fd6efb9e Nederlands_Ondertiteld
	#			CHANNEL_ID="f09c1ff6e402fdff707afd56b71f43c0f968c00f"
	#						f09c1ff6e402fdff707afd56b71f43c0f968c00f
	
	
	BID_AMT="0.001"
	
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
	echo "STR1=$'\n'" >> command3.sh
	echo -n "$COMMAND" >> command3.sh 

	if test -f "add_fix.txt"; then
		echo "Adding:"
		cat add_fix.txt
		cat add_fix.txt >> command3.sh
	fi
	
	chmod +x command3.sh
		
	echo UPLOADING LANGUAGE=$LANGUAGE
	sleep 1
	
#	echo NOT!!! UPLOADING LANGUAGE=$LANGUAGE
#	return #(remove this for executing the bash script)
	./command3.sh
	echo UPLOADED LANGUAGE=$LANGUAGE
	sleep 2
}

echo "======"

#THUMBNAIL=$(tail -n 1 thumbnails.txt)
THUMBNAIL=$(jq -r .thumbnail $2.info.json)

#THUMBNAIL=$(grep "\.jpg" thumbnails.txt | grep -v "unknown" | tail -n 1)
#if [ "$THUMBNAIL" == ""        ]; then
#	THUMBNAIL=$(grep "\.jpg" thumbnails.txt | tail -n 1)
#	if [ "$THUMBNAIL" == ""        ]; then
#		THUMBNAIL=$(cat thumbnails.txt | tail -n 1)
#	fi
#fi

#THUMBNAIL=$(grep "\.jpg" thumbnails.txt | tail -n 1)

echo "Thumbnail=$THUMBNAIL"
#THUMBNAIL="$(echo $THUMBNAIL | cut -d' ' -f4)"
#echo "Thumbnail=$THUMBNAIL"
echo "======"

## TITLE=$(cat $2.info.json)
## #echo "Description=$DESCRIPTION"
## TITLE="$(echo $TITLE | cut -d',' -f2 | cut -d':' -f2)"
## TITLE=$(echo "$TITLE" | xargs) 

UPLOAD_DATE=$(jq --raw-output .upload_date "$2.info.json")
UPLOAD_DATE=$(echo "$UPLOAD_DATE" | sed -E 's/(....)(..)(..)/\1\-\2\-\3/')
echo "Upload_date=$UPLOAD_DATE"

TITLE=$(jq -r .title $2.info.json)
TITLE=$(echo -n $TITLE | sed "s|\"|\\\\\\\"|g"  )
TITLE="\"(🇳🇱NL "$UPLOAD_DATE") "$TITLE"\""
echo "Title=$TITLE"
echo "======"

DESCRIPTION2=$(cat $2.description)
DESCRIPTION=$(jq -r .description $2.info.json; echo -n "$DESCRIPTION2")

DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s|Show more |\\n|g"  )
DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s| Show less||g"  )

DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s|\"|\\\\\\\"|g"  )

DESCRIPTION=$(echo -n "$DESCRIPTION" | sed "s|$|\"\"\$STR\"\"\\\|g"  )

#DESCRIPTION3=$(cat COMMANDS.SH)
#DESCRIPTION3=$(echo -n "$DESCRIPTION3" | sed "s|\"|\\\\\\\"|g"  )
#DESCRIPTION3=$(echo -n "$DESCRIPTION3" | sed "s|\\\\$|\\\\\\\\|g"  )
#DESCRIPTION3=$(echo -n "$DESCRIPTION3" | sed "s|$|\"\"\$STR1\"\"\\\|g"  )
#DESCRIPTION=$(echo -n "$DESCRIPTION" ; echo ; echo -n "$DESCRIPTION3"  )
#cat COMMANDS.SH >> "$BASENAME.description"

STR=$'\n'

DESCRIPTION="\""$DESCRIPTION""$STR"\" \\"

echo "Description=$DESCRIPTION"
echo "======"

FILENAME="$1"
NAME="${FILENAME%.*}"
echo "Name=$NAME"
NAME=$(echo $NAME | sed 's/\[//g' | sed 's/\]//g')
echo "Name=$NAME"
upload
