#!/bin/bash


IDLE=`ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {printf("%d", $NF/1000000000); exit}'`
echo $IDLE
if [[ "$IDLE" -gt 300 ]]
then
    osascript -e 'display notification "computer is idle" with title "No Screenshots"'
    exit 0
fi

. ~/.dockerfunc

FILE="out/screen.png"
OUT="out/out.jpeg"
mkdir -p out
screencapture -x "$FILE"
DIR=out/`date +"%Y-%m"`
mkdir -p "$DIR"

cat "$FILE" | convert -resize 256^ -resize 640^ - jpeg:- > "$OUT"
# > "$OUT"

SIZE=`du -k "$OUT" | cut -f 1`
NAME=`date +"%Y-%m-%d %H.%M"`

if [[ "0" -eq "$SIZE" ]]
then
    osascript -e 'display notification "convert doesn`t work" with title "Docker"'
    cp "$FILE" "${DIR}/$NAME.png"
else
    cp "$OUT" "${DIR}/$NAME.jpeg"
fi
