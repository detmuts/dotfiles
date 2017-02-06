#!/bin/bash
source $(dirname $0)/config.sh
XPOS=$((345 + $XOFFSET))
WIDTH="50"
LINES="8"

# TODO: constantly poll current volume and redraw when it changes
vol=$(amixer -c 0 get Master | egrep -o "[0-9]+%" | head -1 | egrep -o "[0-9]*")
(
    echo "Vol"
    echo "^ca(1,amixer -c 0 set Master 8+)^bg(#383e4d)^fg($foreground)  +  ^ca()"
    for i in {100..0..20}; do
	      if [ $vol -gt $i ]
	      then
            echo "^bg($white1)  "
	      else
            echo "^bg($background)  "
	      fi
    done
    echo "^ca(1,amixer -c 0 set Master 8-)^bg(#383e4d)^fg($foreground)  -  ^ca()"
    sleep 5
) | dzen2 -fg "$foreground" -bg "$background" -fn "$FONT" -x $XPOS -y $YPOS -w $WIDTH -l $LINES  -h $HEIGHT$ -sa c -ta c -title-name $POPUP -e 'onstart=uncollapse;button1=exit;button3=exit'
