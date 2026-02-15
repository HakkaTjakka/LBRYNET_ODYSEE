#!/usr/bin/env bash
set -euo pipefail   # veiliger script: stop bij fouten, undefined vars, etc.

# Maak output map aan (bestaat al? geen probleem)
mkdir -p output

# Array met alle .mp4 bestanden in huidige map
files=(*.mp4)

# Check of er überhaupt mp4 bestanden zijn
if [ ${#files[@]} -eq 0 ] || [ "${files[0]}" = "*.mp4" ]; then
    echo "Geen .mp4 bestanden gevonden in de huidige map."
    exit 1
fi

echo "Gevonden bestanden: ${#files[@]}"

for f in "${files[@]}"; do
    echo "----------------------------------------"
    echo "Verwerken: $f"

    output_file="output/${f}"

    # Als het bestand al bestaat in output → overslaan (of verwijder deze check als je wilt overschrijven)
    if [[ -f "$output_file" ]]; then
        echo "  → Bestaat al, overslaan: $output_file"
        continue
    fi

    ffmpeg -i "$f" \
        -vf "fps=fps=30,scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:-1:-1:color=black" \
        -strict -2 -c:s mov_text -c:v h264_nvenc -profile:v high -pix_fmt yuv420p -bf:v 3 -preset slow -rc-lookahead 32 \
        -c:a aac -ac 2 -b:a 128k \
        -movflags +faststart \
        -y "$output_file"

    # Als je een andere codec/kwaliteit wilt, pas dan bovenstaande regels aan, bijv:
    # - NVIDIA:   -c:v h264_nvenc -preset p5 -rc constqp -qp 23
    # - Sneller:  -preset veryfast
    # - Hogere kwaliteit: -crf 18

    if [[ $? -eq 0 ]]; then
        echo "Klaar: $output_file"
    else
        echo "FOUT bij verwerken van $f"
    fi
done

echo "----------------------------------------"
echo "Klaar — alle bestanden verwerkt."