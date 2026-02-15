#!/bin/bash

# Function to strip ANSI color codes
strip_ansi() {
    sed 's/\x1B\[[0-9;]*[A-Za-z]//g'
}

rm -f links.txt

declare -g lang=""
declare -g skip="no"
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

LANGUAGE="all"

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
    skip="yes"
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

## echo RECOLL=$RECOLL
## recollq -b -n=0 "\'$RECOLL\'" > list.txt


#recollq -b -n=0 '"'$args'" AND filename:*.nl.srt' > list.txt
recollq -b -n=0 $args AND $RECOLL 2>/dev/null > list.txt 

#recollq -b -n=0 '"'$args'" AND "'$RECOLL'"' > list.txt
#recollq -b -n=0 '"'$args'" AND filename:*.'$lang'.srt' > list.txt
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
    grep_args=$(echo $args | sed "s/ OR /\|/g" | sed "s/ AND /\|/g")
    echo grep_args=$grep_args
#    read -r -p "Druk op Enter om door te gaan... " dummy < /dev/tty
    MATCHES=$(grep -Eoi "$grep_args" "$DIR/$FILENAME" | wc -l)

    echo "***************************************"

    grep -Eni --color=always -B2 "$grep_args" "$DIR/$FILENAME" > hoppa.txt
#    echo $FOUND > hoppa.txt
    cat hoppa.txt

# Read the file, strip colors, then process with awk to extract start times in hh:mm:ss
# cat hoppa.txt | strip_ansi | awk '
# NR % 4 == 2 {
#     # $0 is like: 1094-00:14:16,540 --> 00:14:20,000
#     # Remove the line_num- part
#     sub(/^[0-9]+-/, "", $0)
#     # Now $0 is 00:14:16,540 --> 00:14:20,000
#     # Split to get first timestamp
#     split($1, a, ",")
#     print a[1]
# }'

#/--$/ || NR % 4 != 2 { print }   # print all lines except the timing ones
#{ print }                     # ← prints every line exactly as-is (colors preserved)

##     echo "***************************************"
##     echo MATCHES=$MATCHES
##     echo "***************************************"
##     echo DIR=$DIR
##     echo "***************************************"
##     echo FILENAME=$FILENAME
##     echo "***************************************"
##     ls -altr "$DIR/$FILENAME"
##     echo "***************************************"

 #   FILE_BASE=$(echo "$DIR" | sed 's|/[^/]*$||')
#    echo FILE_BASE=$FILE_BASE
#    echo "***************************************"

#	DIR="${DIR%/*}"    
#exit
#    sleep 2

    FILE_BASE="$DIR"
    SLUG=$(echo "$FILE_BASE" | sed 's/\.[sS][rR][tT]$//; s/[][]//g')

#echo "mp-[AXLX2qL7Lbk].English" | sed 's/[][]//g'

    SLUG="${SLUG//@/}"  
    SLUG="${SLUG// /-}"
    echo SLUG=$SLUG
    if [ "$LANGUAGE" == "all" ]; then

        SLUG2="lbry://"$SLUG".Dutch"
        LINK=$(echo $SLUG2 | sed 's|lbry://|https://odysee.com/|g')
        echo LINK=$LINK

        SLUG2="lbry://"$SLUG".English"
        LINK=$(echo $SLUG2 | sed 's|lbry://|https://odysee.com/|g')
        echo LINK=$LINK

        SLUG2="lbry://"$SLUG".German"
        LINK=$(echo $SLUG2 | sed 's|lbry://|https://odysee.com/|g')
        echo LINK=$LINK

        SLUG2="lbry://"$SLUG".French"
        LINK=$(echo $SLUG2 | sed 's|lbry://|https://odysee.com/|g')
        echo LINK=$LINK
        echo SLUG2=$SLUG2
    else
        SLUG2="lbry://"$SLUG"."$LANGUAGE
        echo SLUG2=$SLUG2
        LINK=$(echo $SLUG2 | sed 's|lbry://|https://odysee.com/|g')

        echo "***************************************"
#        echo -n "***************************************"
#        NR % 4 == 3 { print }    

        cat hoppa.txt | awk '
        NR % 4 == 2 {
            clean = gensub(/\x1B\[[0-9;]*[A-Za-z]/, "", "g", $0)
            sub(/^[0-9]+-/, "", clean)
            split(clean, t, /[ ,]/)          # t[1] = "00:14:16"

            split(t[1], parts, ":")          # parts[1]=hh, [2]=mm, [3]=ss
            seconds = parts[1]*3600 + parts[2]*60 + parts[3]
            # print t[1], seconds
            # printf "%-10s %6d s\n", t[1], seconds

#            printf "%s:%d\n", t[1], seconds
#            print "\033[90m" clean "\033[0m"
#            printf "\n%s \033[38;5;242m'$LINK'?t=%d\033[0m\n", t[1], seconds
            myline_a = t[1]
            myline_b = seconds

            split(t[4], parts, ":")          # parts[1]=hh, [2]=mm, [3]=ss
            myline_a2 = t[4]
            seconds = parts[1]*3600 + parts[2]*60 + parts[3]
            myline_b2 = seconds

            # or:  print t[1] " → " seconds " s"
            # or:  printf "%s → %d seconds\n", t[1], seconds
        }
        NR % 4 == 3 { 
            split($0, parts, ":")       
#            printf "\n%s %s\n\033[38;5;242m'$LINK'?t=%d\033[0m\n", parts[2], $0, myline_b

            printf "%s-%s %s\n\033[38;5;242m'$LINK'?t=%d&e=%d&l=%d\033[0m\n\n", myline_a, myline_a2, parts[2], myline_b, myline_b2, myline_b2-myline_b
            myline_b2 = myline_b2 + 1 

            if (myline_b2-myline_b == 1) {
                myline_b2 = myline_b2 + 1
            }

            printf "yt-dlp \"%s?t=%d\" \\\n --download-sections \"*%d-%d\" \\\n --force-keyframes-at-cuts \\\n -o \"../%s.%d-%d.mp4\"\n", "'$LINK'", myline_b, myline_b, myline_b2, "'$SLUG'", myline_b, myline_b2 >> "links.txt"

# yt-dlp "https://odysee.com/Ontketent_Biden_wereldoorlog_in_laatste_presidentsdagen_Dekker_FVD_trekt_aan_noo.Dutch?t=795" \
#   --download-sections "*795-inf" \
#   --force-keyframes-at-cuts \
#   -o "clip exact vanaf 795.mp4"
#yt-dlp "https://odysee.com/....Dutch?t=795" \
#  --download-sections "*795-1095" \
#  -o "clip 795 tot 1095.mp4"

#            printf "\n%s %s\n\033[38;5;242m'$LINK'?t=%d\033[0m\n", myline_a, $0, myline_b
#            print myline, $0
#            clean = gensub(/\x1B\[[0-9;]*[A-Za-z]/, "", "g", $0)
#            print "\033[90m" clean "\033[0m"
        }    
        ' > timing.txt

        cat timing.txt

        echo "***************************************"
        echo LINK=$LINK

    fi

    echo "***************************************"
    echo MATCHES=$MATCHES
    echo "***************************************"
    echo DIR=$DIR
    echo "***************************************"
    echo FILENAME=$FILENAME
    echo "***************************************"
    ls -altr "$DIR/$FILENAME"
    echo "***************************************"

##     if [ "$skip" == "yes" ]; then
##         echo "DESCRIPTION"
##     else
##         lbrynet resolve "$SLUG2" > resolve.txt
## 
##         if jq -e 'to_entries[0].value.error.name == "NOT_FOUND"' resolve.txt >/dev/null; then
##             echo "Niet gevonden (error name = NOT_FOUND)"
##         else
##             echo "OK (geen NOT_FOUND error)"
##             cat resolve.txt | jq -r 'to_entries[0].value.canonical_url | sub("^lbry://"; "https://odysee.com/")'
##         fi
##     fi
##     echo "***************************************"

    read -r -p "Druk op Enter om door te gaan... " dummy < /dev/tty

    # Jouw code hier
done < list.txt



exit




















#https://odysee.com/@Nederlands_Ondertiteld#0/Ontketent_Biden_wereldoorlog_in_laatste_presidentsdagen_Dekker_FVD_trekt_aan_noo.Dutch#9
#/@English_Subtitles:b/


###         while IFS= read -r line; do
###             # Skip empty lines
###             [[ -z "$line" ]] && continue
### 
###             # Split hh:mm:ss
###             IFS=':' read -r hh mm ss msec <<< "$line"
### 
###             # Convert to seconds
###             total=$(( hh * 3600 + mm * 60 + ss ))
### 
### #           echo "$line → $total seconds"
###             echo $hh":"$mm":"$ss LINK=$LINK"?t="$total
### #            echo $line LINK=$LINK"?t="$total
###         done < timing.txt
#https://odysee.com/@English_Subtitles:b/mh17.the.plane.crash.that.shook.the.world.2024.1080p.web.h264-cbfm.English:0?t=964

#    LINK=$(echo $SLUG | sed 's|lbry://|https://odysee.com/@Nederlands_Ondertiteld:0/|g')

#/--$/ || NR % 4 != 2 { print }   # print all lines except the timing ones
#{ print }                     # ← prints every line exactly as-is (colors preserved)

##         cat hoppa.txt | awk '
##         NR % 4 == 2 {
##             # clean the timing line and extract hh:mm:ss
##             clean = gensub(/\x1B\[[0-9;]*[A-Za-z]/, "", "g", $0)
##             sub(/^[0-9]+-/, "", clean)
##             split(clean, t, /[ ,]/)
##             # print "→ START TIME:", t[1]           # or do whatever you want with it
##             print t[1]           
##             # print clean                         # optional: also show cleaned timing line
##         }
##         ' > timing.txt



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


yt-dlp "https://odysee.com/Ontketent_Biden_wereldoorlog_in_laatste_presidentsdagen_Dekker_FVD_trekt_aan_noo.Dutch?t=795" \
  --download-sections "*795-inf" \
  --force-keyframes-at-cuts \
  -o "clip exact vanaf 795.mp4"