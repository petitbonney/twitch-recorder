#!/bin/bash
set -euo pipefail

CHANNEL=""
OUTPUT_DIR="/output"
CRF=23
PRESET="veryfast"
TOKEN=""

usage() {
  echo "Usage: $0 -c <channel> -o <output_dir> [-q <crf>] [-p <preset>] [-t <oauth_token>]"
  echo "  -c   Twitch channel name (required)"
  echo "  -o   Output directory (default: $OUTPUT_DIR)"
  echo "  -q   CRF quality (default: $CRF)"
  echo "  -p   x264 preset (default: $PRESET)"
  echo "  -t   Twitch OAuth token (optional)"
  exit 1
}

# Parse flags
while getopts "c:o:q:p:t:h" opt; do
  case $opt in
    c) CHANNEL="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    q) CRF="$OPTARG" ;;
    p) PRESET="$OPTARG" ;;
    t) TOKEN="$OPTARG" ;;
    h|*) usage ;;
  esac
done

if [[ -z "$CHANNEL" ]]; then
  echo "Error: channel is required"
  usage
fi

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTFILE="${OUTPUT_DIR}/${CHANNEL}_${TIMESTAMP}.mkv"

echo "Recording Twitch channel: $CHANNEL"
echo "Saving to: $OUTFILE"
echo "Settings: CRF=$CRF, preset=$PRESET"

# Build streamlink command
if [[ -n "$TOKEN" ]]; then
  STREAMLINK_CMD=(streamlink "--twitch-api-header=Authorization=OAuth $TOKEN" --stdout "https://twitch.tv/${CHANNEL}" best)
else
  STREAMLINK_CMD=(streamlink --stdout "https://twitch.tv/${CHANNEL}" best)
fi

"${STREAMLINK_CMD[@]}" | \
  ffmpeg -loglevel warning -fflags +genpts -i - \
    -c:v libx264 -preset "$PRESET" -crf "$CRF" \
    -c:a aac -b:a 128k \
    -y "$OUTFILE"
