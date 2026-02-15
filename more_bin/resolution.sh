#!/usr/bin/env bash

# Enable case-insensitive globbing and allow empty matches
shopt -s nocaseglob nullglob

echo "Resolution of images in current directory:"
echo "----------------------------------------"

for file in *.jpg *.jpeg *.png *.gif *.bmp *.webp *.tif *.tiff; do
    # nullglob ensures the loop is skipped when no files match
    resolution=$(ffprobe -v quiet -select_streams v:0 \
        -show_entries stream=width,height \
        -of csv=p=0:s=x \
        "$file" 2>/dev/null)

    if [[ -n "$resolution" ]]; then
        printf "%-45s  →  %s\n" "$file" "$resolution"
    else
        printf "%-45s  →  not an image / error\n" "$file"
    fi
done

# Optional: turn it off again if you care (usually not necessary)
# shopt -u nocaseglob nullglob