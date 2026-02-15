SRC="."
DST="/mnt/EXTENTION/Storage/SUBTITLE_ARCHIVE/SEARCH"   # deze map mag nog niet bestaan of mag leeg zijn

# mkdir -p "$DST"
# find "$SRC" -type f -name '*.nl.srt' -print0 | cpio -0 -pdm "$DST/"
# #find "$SRC" -type f -name '*.srt' -print0 > kut.txt
# 
# exit

find "$SRC" -type f -name '*.nl.srt.double' -print0 | while IFS= read -r -d '' file; do
    relpath="${file#"$SRC"/}"                  # bijv. sub/map/film.double
    targetdir="$DST/${relpath%/*}"             # bijv. /doel/sub/map
    targetfile="${relpath##*/}"                # film.double
    targetfile_noext="${targetfile%.double}"   # film

    if test -f "$targetdir/$targetfile_noext"; then
        echo "Overwriting: $targetfile_noext"
    else
        echo "        New: $targetfile_noext"
    fi

    mkdir -p "$targetdir"
    cp -p "$file" "$targetdir/$targetfile_noext"
done