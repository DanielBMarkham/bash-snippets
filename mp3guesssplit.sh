#!/bin/bash


# script to chop audio file into chunks of around TARGETMINUTES minutes
# requires ffmpeg

# INIT VARS OK
INCOMING="${1:-in.mp3}"
OUTGOING="${2:-out.mp3}"
TARGETLENGTH="${3:-20}"

echo $TARGETLENGTH

#duration=$(ffprobe "$INCOMING" 2>&1 | awk '/Duration/ { print $2 }')
#hours=$(echo -e $duration | awk -F ":" '{print $1}')
#minutes=$(echo -e $duration | awk -F ":" '{print $2}')
#seconds=$(echo -e $duration | awk -F ":" '{print $3}')
#lengthinminutes=$(expr $(expr $hours \* 60 ) + $minutes)
#TARGETNUMBEROFCHUNKS=$(expr $lengthinminutes / $TARGETMINUTES)
#echo "Length in minutes: $lengthinminutes"
#echo
#echo "Target number of chunks of size $TARGETMINUTES minutes: $TARGETNUMBEROFCHUNKS"

getFileLengthInMinutes(){
	FILENAME=$1
	TARGETMINUTES=$2
	duration=$(ffprobe "$FILENAME" 2>&1 | awk '/Duration/ { print $2 }')
	hours=$(echo -e $duration | awk -F ":" '{print $1}')
	minutes=$(echo -e $duration | awk -F ":" '{print $2}')
	seconds=$(echo -e $duration | awk -F ":" '{print $3}')
	lengthinminutes=$(expr $(expr $hours \* 60 ) + $minutes)
	TARGETNUMBEROFCHUNKS=$(expr $lengthinminutes / $TARGETMINUTES)
	#echo "Length in minutes: $lengthinminutes"
	#echo
	#echo "Target number of chunks of size $TARGETMINUTES minutes: $TARGETNUMBEROFCHUNKS"
	echo "$TARGETNUMBEROFCHUNKS"
	}
	
numberOfChunksBasedOnSilenceLength() {
	#echo
	#echo "d $1"
	#echo " dd $2"
	#echo
	echo "$(ffmpeg -i "$1" -af silencedetect=d=$2 -f null - |& awk '/silencedetect/ {print $4,$5}' | wc -l)"
	}

GOALCHUNKS=$(getFileLengthInMinutes $INCOMING 20)
#echo "goal number of chunks = $GOALCHUNKS"


numchunks=0
COUNT=50
while [ $COUNT -gt 0 ] && [ $numchunks -lt "$GOALCHUNKS" ] ;do
         #echo $COUNT
         SILENCESIZE=$(echo "$COUNT / 10" | bc -l)
	 parm=$(printf "%0.2f\n" "$SILENCESIZE")
	 #echo "goal number of chunks = $dog"
	 echo "$parm"
	 numchunks=$(numberOfChunksBasedOnSilenceLength "$INCOMING $parm")
	 #TARGETLENGTH
	 echo "$numchunks"
	 echo
         COUNT=$COUNT-1
  done
  
  echo
  echo "SDAFASDFSD"
  echo "Silence size should be: $parm"
