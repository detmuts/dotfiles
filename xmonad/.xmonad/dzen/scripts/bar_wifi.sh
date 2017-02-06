#!/bin/bash

source $(dirname $0)/config.sh

ESSID=`iwconfig wlp1s0 | sed -n "1p" | awk -F '"' '{print $2}'`
QUAL=`iwconfig wlp1s0 | grep 'Link Quality=' | awk '{gsub(/[=/]/," "); print $3}'`
MAX=`iwconfig wlp1s0 | grep 'Link Quality=' | awk '{gsub(/[=/]/," "); print $4}'`
PERC=`echo $QUAL*100/$MAX | bc`

color=""

if [[ $PERC -lt 20 ]]; then
	ICON="wireless1.xbm"
	color="^fg($warning)"
elif [[ $PERC -lt 40 ]]; then
	ICON="wireless2.xbm"
	color="^fg($notify)"
elif [[ $PERC -lt 60 ]]; then
	ICON="wireless3.xbm"
elif [[ $PERC -lt 80 ]]; then
	ICON="wireless4.xbm"
elif [[ $PERC -lt 101 ]]; then
	ICON="wireless5.xbm"
fi

PERCBAR=`echo -e "$PERC"\
            | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w`

ICON="^i($ICONDIR/$ICON)"
echo "$color$ICON^fg() $PERCBAR"
