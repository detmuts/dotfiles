#!/bin/bash

source $(dirname $0)/config.sh

AMASTER=`amixer -c 0 get Master | awk 'END{gsub(/\[|\]|%/,""); print $4}'`
ASTAT=`amixer -D pulse get Master | awk 'END{gsub(/\[|\]|%/,""); print $6}'`
ICON=""

if [[ $ASTAT = "on" ]]; then
    ICON="spkr_01.xbm"
    PERCBAR=`echo "$AMASTER"\
        | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w`
else
    ICON="spkr_02.xbm"
    PERCBAR=`echo 0 \
        | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w`
fi

ICON="^i($ICONDIR/$ICON)"
echo "$ICON $PERCBAR"
