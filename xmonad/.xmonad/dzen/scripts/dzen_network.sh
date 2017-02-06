#!/bin/bash
source $(dirname $0)/config.sh
XPOS=$((80 + $XOFFSET))
WIDTH="340"
LINES="8"

essid=$(iwconfig wlp1s0 | sed -n "1p" | awk -F '"' '{print $2}')
mode=$(iwconfig wlp1s0 | sed -n "1p" | awk -F " " '{print $3}')
freq=$(iwconfig wlp1s0 | sed -n "2p" | awk -F " " '{print $2}' | cut -d":" -f2)
mac=$(iwconfig wlp1s0 | sed -n "2p" | awk -F " " '{print $6}')
qual=$(iwconfig wlp1s0 | sed -n "6p" | awk -F " " '{print $2}' | cut -d"=" -f2)
lvl=$(iwconfig wlp1s0 | sed -n "6p" | awk -F " " '{print $4}' | cut -d"=" -f2)
rate=$(iwconfig wlp1s0 | sed -n "3p" | awk -F "=" '{print $2}' | cut -d" " -f1)
inet=$(ifconfig wlp1s0 | sed -n "2p" | awk -F " " '{print $2}')
netmask=$(ifconfig wlp1s0 | sed -n "2p" | awk -F " " '{print $4}')
broadcast=$(ifconfig wlp1s0 | sed -n "2p" | awk -F " " '{print $6}')

(
    echo "Network"
    echo " Essid: ^fg($highlight)$essid"
    echo " Freq: ^fg($highlight)$freq GHz ^fg() Band: ^fg($highlight)$mode"
    echo " Down: ^fg($highlight)$rate MB/s  ^fg() Quality: ^fg($highlight)$qual"
    echo " IP: ^fg($white)$inet"
    echo " Netmask: ^fg($white)$netmask"
    echo " Broadcast: ^fg($white)$broadcast"
    echo " MAC: ^fg($highlight)$mac"
    echo " "
    sleep 5
) | dzen2 -fg "$foreground" -bg "$background" -fn "$FONT" -x $XPOS -y $YPOS -w $WIDTH -l $LINES -h $HEIGHT -ta c -sa l -title-name $POPUP -e 'onstart=uncollapse;button1=exit;button3=exit'
