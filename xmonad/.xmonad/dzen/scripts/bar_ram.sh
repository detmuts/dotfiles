#!/bin/bash
source $(dirname $0)/config.sh

FREE=`free -m | awk 'NR == 2 {gsub(/%/,""); print $3}'`
MAX=`free -m | awk 'NR == 2 {gsub(/%/,""); print $2}'`
PERC=`echo $FREE*100/$MAX | bc`

ICON="mem.xbm"
if [[ $PERC -gt 75 ]]; then
    PERCBAR=`echo -e "$PERC"\
        | gdbar -bg $bar_bg -fg $warning -h $bar_h -w $bar_w`
else
    PERCBAR=`echo -e "$PERC"\
        | gdbar -bg $bar_bg -fg $bar_fg -h $bar_h -w $bar_w`
fi

ICON="^i($ICONDIR/$ICON)"
echo "$ICON $PERCBAR"
