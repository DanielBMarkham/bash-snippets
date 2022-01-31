#!/bin/bash

# Takes path to mp3 file, framerate, and name of output

# Initialize variables
MP3FILE="${1:-mymp3.mp3}"
FRAMERATE="${2:-2}"
MONTAGENAME="${3:-mymontage.mp4}"

# Change file format to png if you can
# ====================================
GLOBIGNORE="*.png"
for f in *; do 
    ffmpeg -i "$f" "${f%.*}.png"
done
unset GLOBIGNORE;


# Delete everything not a png
# ===========================
GLOBIGNORE="*.png"
rm *
unset GLOBIGNORE;


# Randomly numerize the files
# ===========================
((ls) | shuf) | grep -v "/$" | cat -n | while read n f; do mv -n "${f}" "$(printf "%04d" $n).png" --; done


# Get the number of seconds in the target mp3 file
# For our sample here, we're using the song 'code monkey', ie ../CodeMonkey.mp3 which is in the parent directory
# ===================================================
timegoal=$(ffmpeg -i "$MP3FILE" 2>&1 | grep "Duration" | grep -o " [0-9:.]*, " | head -n1 | tr ',' ' ' | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')

# Attach mp3 to video of slides
# This has an output file of out.mp4 in the parent directory
# You need a target number of frames for each slide
# It's 1/x where x is the number of seconds for each slide
# ie, 1/2 means 1 slide every 2 seconds
# likewise 2 (like our example) means 2 slides per second

ffmpeg -r "$FRAMERATE" -t $timegoal -i "%04d.png" -i "$MP3FILE" -c:v libx264 -pix_fmt yuv420p -vf "scale=1280:720, pad=ceil(iw/2)*2:ceil(ih/2)*2" -preset slow -crf 18  "$MONTAGENAME"
