#!/bin/bash

# Initialize counter
COUNT=0
find . -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.mp4" \) > sorted.txt
subl sorted.txt

echo PRESS ENTER
read aaa

while IFS= read -r line; do
  filename=${line:2}  # Remove './' from the filename
#  echo "$filename"

  COUNT=$((COUNT + 1))
  COUNT_ZERO=$(printf '%04d\n' "$COUNT")

  # Extract file extension (case-insensitive)
  ext=$(echo "$filename" | awk -F . '{print tolower($NF)}')
  echo mv "$filename" "jow_${COUNT_ZERO}.${ext}"
  mv "$filename" "jow_${COUNT_ZERO}.${ext}"
done < sorted.txt
