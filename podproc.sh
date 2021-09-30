#!/bin/bash


# script to preprocess and move podcast files to gdrive
# requires ffmpeg and ffmpeg-normalize
# also requires gdrive to be set up. See https://olivermarshall.net/how-to-upload-a-file-to-google-drive-from-the-command-line/?utm_source=pocket_mylist

STARTTIME=`date "+%B %V %T.%3N"`
# INIT VARS OK
INFILE="$(basename -s .mp4 "${1:-temp.mp4}")"
PROCESSINGDIRECTORY=podproctempdir
FILERUNLENGTH=$(ffmpeg -i "$INFILE".mp4 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,//)



# INIT FILES AND DIRS OK
if [ -f "$INFILE".mp4 ]; then
echo "The file '$INFILE' exists."
mkdir -p "$PROCESSINGDIRECTORY"

STARTFILESIZE=$(stat -c%s "$INFILE".mp4)
STARTFILESIZEINMB=$(( $( stat -c '%s' "$INFILE".mp4)/1024/1024))MB

echo ""
date "Begin script at " "$STARTTIME"
echo "Size of $INFILE = $STARTFILESIZE bytes."
echo ""


echo Normalizing and converting file "$INFILE"
# Move into processdirectory to do our work
cp ./"$INFILE".mp4 ./"$PROCESSINGDIRECTORY"
cd "$PROCESSINGDIRECTORY" || exit

# ONLY DO THIS ONCE, NOT TWICE, UNLESS VERY NOISY
# nice -20 ffmpeg -i "$INFILE".mp4 -af "afftdn=nf=-25" temp2.mp4
# nice -20 ffmpeg -i temp2.mp4 -af "highpass=f=100, lowpass=f=4000" temp3.mp4
nice -20 ffmpeg -i "$INFILE".mp4 -af "highpass=f=100, lowpass=f=4000" temp3.mp4

nice -20 ffmpeg-normalize temp3.mp4
nice -20 ffmpeg -i  normalized/temp3.mkv temp4.mp4

echo "Normalizing done. Now making separate audio file"

nice -20 ffmpeg -i  temp4.mp4 temp4.mp3

echo "Podcast preprocessing complete."
echo "delete incoming file that was just processed"
rm "$INFILE".mp4

echo "Renaming last temp file to incoming file."
mv temp4.mp4 "$INFILE".mp4
mv temp4.mp3 "$INFILE".mp3

echo "Deleting remaining temp files"
echo ""

rm temp*
rm normalized/temp3.mkv

echo "upload resulting file to gdrive"

UPLOADBEGINTIME=`date "+%B %V %T.%3N"`
nice -20 gdrive upload "$INFILE".mp3 -p 1AmrPilvwu6z6HwUTwN_rr2hOG2sjDni2
nice -20 gdrive upload "$INFILE".mp4 -p 1H1x-chUXuTLVDZ0-a3f3BmSy3TET2hXx

echo "files moved. modified files that were uploaded are left in directory"

echo ""
ENDFILESIZE=$(stat -c%s "$INFILE".mp4)
ENDFILESIZEINMB=$(( $( stat -c '%s' "$INFILE".mp4)/1024/1024))MB

echo "splitting up into 4 chunks for possible later transcription"
# there's a script to figure out the exact number of chunks.
# For now, 4 is most always going to work. Use that
# Don't code things you don't need! :)
mp3splt -s -pmin=1.2 -pnt=4 "$INFILE".mp3
echo "done"


echo "Size of $INFILE".mp4" = $ENDFILESIZE bytes."

else
echo "The file '$INFILE' does not exist."
echo ""

fi

#ENDTIME=$(date '+%B %V %T.%3N')
#ENDTIME=`date "+%B %V %T.%3N"`
ENDTIME=`date "+%B %V %T.%3N"`
date "End script at " "$ENDTIME"
echo ""
echo "###"
echo "Processed file: $INFILE".mp4
echo "Run legnth: $FILERUNLENGTH"
echo "Start Time: $STARTTIME"
echo "Start Filesize: $STARTFILESIZEINMB"
echo "Upload begin , end: $ENDTIME, $UPLOADBEGINTIME"
echo "End Time: $ENDTIME"
echo "End Filesize: $ENDFILESIZEINMB"
echo "###"
echo ""
