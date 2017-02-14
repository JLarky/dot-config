#!/bin/bash

if [[ `uname` == "Linux" ]]
then
    IDLE=`xprintidle | awk '{printf("%d", $NF/1000); exit}'`
else
    IDLE=`ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {printf("%d", $NF/1000000000); exit}'`
fi

echo $IDLE

if [[ "$IDLE" -gt 300 ]]
then
    hash kdialog 2>/dev/null && kdialog --title "No screenshots" --passivepopup "Computer is idle" 1
    hash osascript 2>/dev/null && osascript -e 'display notification "computer is idle" with title "No Screenshots"'
    exit 0
fi

[[ -f ~/.dockerfunc ]] && source ~/.dockerfunc

FILE="out/screen.png"
OUT="out/out.jpeg"
mkdir -p out
DIR=out/`date +"%Y-%m"`
mkdir -p "$DIR"

hash screencapture 2>/dev/null && screencapture -x "$FILE"
hash scrot 2>/dev/null && scrot "$FILE"

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
