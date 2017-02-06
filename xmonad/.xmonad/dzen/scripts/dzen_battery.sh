#!/bin/bash
source $(dirname $0)/config.sh
XPOS=$((400 + $XOFFSET))
WIDTH=210
LINES=3


battime=$(acpi -b | sed -n "1p" | awk -F " " '{print $5}')
batperc=$(acpi -b | sed -n "1p" | awk -F " " '{print $4}' | head -c3)
batstatus=$(acpi -b | cut -d',' -f1 | awk -F " " '{print $3}')

(
    echo "Battery"
    echo " Status: ^fg($highlight)$batstatus"
    echo " ^fg()Charge: ^fg($highlight)$batperc"
    echo " ^fg()Left: ^fg($highlight)$battime"
    sleep 5
) | dzen2 -fg "$foreground" -bg  "$background" -fn "$FONT" -x $XPOS -y $YPOS -w $WIDTH -l $LINES -h $HEIGHT -ta c -sa l -title-name $POPUP -e 'onstart=uncollapse;button1=exit;button3=exit'
