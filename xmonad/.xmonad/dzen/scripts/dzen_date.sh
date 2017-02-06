#!/bin/bash
source $(dirname $0)/config.sh
XPOS=$((0 + $XOFFSET))
WIDTH=240
LINES=8

time=$(TZ="Europe/Brussels" date | awk -F " " '{print $4}')
calendar=$(cal -1)
datea=$(date +%a)
dateb=$(date +%b)
dated=$(date +%d)
datey=$(date +%Y)

(
    echo "^fg($highlight)$datea $dateb $dated $datey"
    echo "$calendar"
    sleep 5
) | dzen2 -fg "$foreground" -bg "$background" -fn "$FONT" -x $XPOS -y $YPOS -w $WIDTH -l $LINES -h $HEIGHT -ta c -sa c -title-name $POPUP -e 'onstart=uncollapse;button1=exit;button3=exit'
