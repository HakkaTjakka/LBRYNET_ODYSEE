#!/bin/bash

# Save as: find-odysee-url.sh
# Usage: ./find-odysee-url.sh "Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-[kOebfGSRqJM].English"
#DIR="Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-[kOebfGSRqJM]"
# DIR="The_plan_layed_out_and_those_behind_it_Recording_from_1967_Myron_C_Fagan_The_Illuminati_and_the_CFR-[gySJk1rxhyU]"
# DIR=""

#recollq -b -n=0 '"'$*'"' > list.txt
#!/usr/bin/env bash

rm claim_not_found.txt
rm claim_found.txt
rm base_link_videosource_list.txt
declare -g lang=""
declare -g RECOLL=""
declare -a args=()

while (( $# > 0 )); do
 case "$1" in
     --language)
         shift
         if (( $# == 0 )); then
             echo "Error: --language requires a value" >&2
             exit 2
         fi
         lang="$1"
         ;;
     *)
         args+=("$1")
         ;;
 esac
 shift
done
echo lang=$lang
echo args=$args

if [ -z "$lang" ]; then
    lang="*"
    RECOLL='filename:*.srt'
    echo "Language=$lang"
    echo "Language=all"
elif [ "$lang" == "all" ]; then
    lang="*"
    RECOLL='filename:*.srt'
    echo "Language=$lang"
    echo "Language=all"
elif [ "$lang" == "desc" ]; then
    lang="*"
    RECOLL='filename:*.description'
    echo "Language=$lang"
    echo "Language=all"
else
    echo "Language=$lang"
    if [ "$lang" == "en" ]; then
        RECOLL='filename:*.en.srt'
        LANGUAGE="English"
    elif [ "$lang" == "nl" ]; then
        RECOLL='filename:*.nl.srt'
        LANGUAGE="Dutch"
    elif [ "$lang" == "de" ]; then
        RECOLL='filename:*.de.srt'
        LANGUAGE="German"
    elif [ "$lang" == "fr" ]; then
        RECOLL='filename:*.fr.srt'
        LANGUAGE="French"
    fi
    echo "LANGUAGE=$LANGUAGE"
fi
#exit
#recollq -b -n=0 '"'$args'" AND filename:*.nl.srt' > list.txt
echo RECOLL=$RECOLL

# echo recollq -b -n=0 "'$RECOLL'" 
# exit
recollq -b -n=0 $RECOLL > list.txt
#recollq -b -n=0 '"'$args'" AND filename:*.'$lang'.srt' > list.txt

LINE=$(cat list.txt | wc -l)
echo LINES=$LINE 
read aaaa

while IFS= read -r line; do
    echo "Regel: $line"

    # DIR=$(echo $line | sed "s/\.nl\.srt\.double//")
    # echo DIR=$DIR

#    path="/mnt/.../This_is_an_Anti_Human_Agenda_David_Icke_The_Trueman_Show_227-[TIBgVc7DalE]/bestand.srt"

    DIRNAME="${line%/*}"           # alles tot laatste /
    DIR="${DIRNAME##*/}"      # alles ná laatste /
    FILENAME=$(basename "$line")

#    MATCHES=$(grep -oi "$args" "$DIR/$FILENAME" | wc -l)
#    echo "***************************************"
#    grep -ni  --color=always -B2 "$args" "$DIR/$FILENAME"
#    echo "***************************************"
#    echo MATCHES=$MATCHES
    echo "***************************************"
    echo DIR=$DIR
    echo "***************************************"
    echo FILENAME=$FILENAME
    echo "***************************************"
    ls -altr "$DIR/$FILENAME"
    echo "***************************************"

 #   FILE_BASE=$(echo "$DIR" | sed 's|/[^/]*$||')
#    echo FILE_BASE=$FILE_BASE
#    echo "***************************************"

#	DIR="${DIR%/*}"    
#exit
#    sleep 2

    FILE_BASE="$DIR"
    SLUG=$(echo "$FILE_BASE" | sed 's/\.[sS][rR][tT]$//; s/[][]//g')

#echo "mp-[AXLX2qL7Lbk].English" | sed 's/[][]//g'

    echo SLUG=$SLUG
    SLUG="${SLUG//@/}"  
    SLUG="${SLUG// /-}"
#    SLUG="lbry://"$SLUG".Dutch"
    SLUG="lbry://"$SLUG"."$LANGUAGE

#    SLUG="lbry://"$SLUG".Dutch"
    echo SLUG=$SLUG
    LINK=$(echo $SLUG | sed 's|lbry://|https://odysee.com/|g')
#    LINK=$(echo $SLUG | sed 's|lbry://|https://odysee.com/@Nederlands_Ondertiteld:0/|g')
    echo LINK=$LINK
    echo "***************************************"

#https://odysee.com/@Nederlands_Ondertiteld#0/Ontketent_Biden_wereldoorlog_in_laatste_presidentsdagen_Dekker_FVD_trekt_aan_noo.Dutch#9
#/@English_Subtitles:b/

    DESCRIPTION=$(echo "/mnt/EXTENTION/Storage/SUBTITLE_ARCHIVE/UNZIPPED/$DIR/$DIR.description")
##     if [ -f "$DIR/$DIR.description" ]; then
##         echo "FILE: $DIR.description PRESENT"
##     else
##         cp "$DESCRIPTION" "$DIR"
##         echo "COPYING: $DESCRIPTION TO $DIR"
##     fi

    if [ -f "$DESCRIPTION" ]; then
        VIDEO_SOURCE=$(grep -i "Video Source: " "$DESCRIPTION" | sed "s/Video Source: //")
        echo "VIDEO SOURCE: $VIDEO_SOURCE"
    else
        DESCRIPTION="No discription file"
    fi

    echo "FILE_BASE:    $FILE_BASE" >> base_link_videosource_list.txt
    echo "LINK:         $LINK" >> base_link_videosource_list.txt
    echo "VIDEO_SOURCE: $VIDEO_SOURCE" >> base_link_videosource_list.txt
    echo "***************************************" >> base_link_videosource_list.txt

##     RESOLVE=$(lbrynet resolve "$SLUG" 2>&1)
## 
##     if echo "$RESOLVE" | grep -q '"name": *"NOT_FOUND"'; then
##         echo "Claim not found"
## 
##         echo "FILE_BASE:    $FILE_BASE" >> claim_not_found.txt
##         echo "VIDEO_SOURCE: $VIDEO_SOURCE" >> claim_not_found.txt
##         echo "***************************************" >> claim_not_found.txt
## 
## #        if [ -f "/mnt/EXTENTION/Storage/SUBTITLE_ARCHIVE/UNZIPPED/$DIR/$DIR.description" ]; then
## #            VIDEO_SOURCE=$(grep -oi "Video Source: " "$DIR/$FILENAME")
## #            echo "VIDEO SOURCE: $VIDEO_SOURCE"
## ##            cat add_fix.txt
## #        fi
## 
##         # or: return 1 / exit 1 / handle accordingly
##     elif echo "$RESOLVE" | grep -q '"error"'; then
##         echo "Some other resolve error"
##     else
##         echo "Claim exists"
##         JQ=$(echo $RESOLVE | jq -r 'to_entries[0].value.canonical_url | sub("^lbry://"; "https://odysee.com/")')
##         echo JQ=$JQ
##         echo "FILE_BASE:    $FILE_BASE" >> claim_found.txt
##         echo "VIDEO_SOURCE: $VIDEO_SOURCE" >> claim_found.txt
##         echo "CLAIM:        $JQ" >> claim_found.txt
##         echo "***************************************" >> claim_found.txt
##     fi

#    RESOLVE=$(lbrynet resolve "$SLUG")
#    read -r -p "Druk op Enter om door te gaan... " dummy < /dev/tty
#    sleep 1
    # Jouw code hier
done < list.txt



exit
DIR="Veilig_bij_jezelf_met_Fleur_van_Groningen_The_Trueman_Show_233-[gtXVAFqNDNQ]"

FILE_BASE="$DIR"

# Extract slug: remove extension + optional [YT-ID] part, keep the title part
#SLUG=$(echo "$FILE_BASE" | sed 's/\.[sS][rR][tT]$//; s/\[.*\]//; s/\.English$/.English/; s/\.Dutch$/.Dutch/')
SLUG=$(echo "$FILE_BASE" | sed 's/\.[sS][rR][tT]$//; s/\[//; s/\]//')
#SLUG=$(echo "$FILE_BASE" )
# 
# # Trim whitespace just in case
# SLUG=$(echo "$SLUG" | xargs)

echo $SLUG
SLUG="lbry://"$SLUG".English"
echo $SLUG

#exit

lbrynet resolve "$SLUG" | jq -r 'to_entries[0].value.canonical_url | sub("^lbry://"; "https://odysee.com/")'

# recollq -b '"trump" AND filename:*.srt.double' | wc -l
# recollq -b '"trump" AND filename:*.srt.double' | wc -l
exit
                        Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-[kOebfGSRqJM]
lbrynet resolve "lbry://Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-kOebfGSRqJM.English" | jq -r 'to_entries[0].value.canonical_url | sub("^lbry://"; "https://odysee.com/")'

# The_plan_layed_out_and_those_behind_it_Recording_from_1967_Myron_C_Fagan_The_Illuminati_and_the_CFR

if [[ -z "$SLUG" ]]; then
  echo "Could not extract slug from: $FILE_BASE"
  exit 1
fi

echo "Trying slug: $SLUG"

lbrynet claim search --text="lbry://$SLUG" --page_size=20 --no_totals

exit
lbrynet resolve "lbry://$SLUG" 2>/dev/null | \
jq -r 'to_entries[0].value.canonical_url // "Not found" | sub("^lbry://"; "https://odysee.com/")'

exit



### FILENAME="$DIR.info.json"
### 
### echo DIR=\""$DIR"\"
### echo FILENAME=\""$FILENAME"\"
### 
### 
### TITLE=$(cat "$DIR/$FILENAME" | jq -r '.title')
### echo TITLE=\""$TITLE"\"
### 
### # lbrynet claim search --text="$TITLE" --page_size=20 --no_totals

lbrynet resolve "lbry://Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-kOebfGSRqJM.English" | \
jq -r 'to_entries[0].value.canonical_url | sub("^lbry://"; "https://odysee.com/")'


exit



lbrynet resolve "lbry://Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-kOebfGSRqJM.English" | \
jq -r 'to_entries[0].value.canonical_url'




Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-[kOebfGSRqJM].nl.srt.double

lbrynet claim search --text="Xi_Poetin_en_Modi_zetten_zich_af_van_het_Westen_tijdens_SCO-top-[kOebfGSRqJM]" --page_size=20 --no_totals

lbrynet claim search text="Xi, Poetin en Modi zetten zich af van het Westen tijdens SCO-top"
