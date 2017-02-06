#!/bin/bash

source $(dirname $0)/config.sh

BAT=`acpi -b | awk '{gsub(/%,/,""); print $4}' | sed 's/%//g'`
STATUS=`acpi -b | awk '{gsub(/,/,""); print $3}'`
color=""

if [[ $BAT -lt 20  ]]; then
    ICON="bat_empty_01.xbm"
    if [[ $STATUS != "Charging" ]]; then
        FG=$warning
    else
        FG=$bar_fg
    fi
    BATBAR=`echo -e "$BAT"\
        | gdbar -bg $bar_bg -fg $FG -h 1 -w $bar_w`

    # TODO: figure out a way to modify config.sh variables
    # ALT: write everything to a fifo pipe
    #if [[ "$BAT" -lt "$PREVBAT" ]]; then
    #    notify-send "Battery" "Warning, battery is below 20 percent!" -u critical -t 3000
    #    PREVBAT="$BAT"
    #fi
else

    if [[ $BAT -lt 40 ]]; then
        ICON="bat_low_01.xbm"
    else
        ICON="bat_full_01.xbm"
    fi
    BATBAR=`echo -e "$BAT"\
                 | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w`
fi

if [[ $STATUS != "Discharging" ]]; then
    ICON="ac.xbm"
fi

ICON="^i($ICONDIR/$ICON)"
echo "^fg($FG)$ICON $BATBAR"
