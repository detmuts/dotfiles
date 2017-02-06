#!/bin/bash
source $(dirname $0)/config.sh
XPOS=$((305 + $XOFFSET))
WIDTH=380
LINES=16

cputemp="^fg($white0)^i($ICONDIR/temp.xbm)^fg() Temp ^fg($highlight)$(sensors | grep "temp1" | tr -s " " | awk -F'[ ]' '{ print $2 }' | head -1)"
cpuutiluser=$(iostat -c | sed -n "4p" | awk -F " " '{print $1}')
cpuutilsystem=$(iostat -c | sed -n "4p" | awk -F " " '{print $3}')
cpuutilidle=$(iostat -c | sed -n "4p" | awk -F " " '{print $6}')
ramtotal=$(free -m | sed -n "2p" | awk -F " " '{print $2}')
ramused=$(free -m | sed -n "2p" | awk -F " " '{print $3}')

kernel="^fg($white0)^i($ICONDIR/arch_10x10.xbm)^fg() Kernel ^fg($highlight)$(uname -r)"
packages="^fg($white0)^i($ICONDIR/pacman.xbm)^fg() Packages ^fg($highlight)$(pacman -Q | wc -l)"
uptime="^fg($white0)^i($ICONDIR/net_up_01.xbm)^fg() Uptime ^fg($highlight)$(uptime | awk '{gsub(/,/,""); print $3}')"

hddtitle=$(df -h | head -1)
hddtotal=$(df -h --total | tail -1)

cpu_bar_total=`"$SCRIPTDIR"/bar_cpu.sh 0`
cpu_bar_0=`"$SCRIPTDIR"/bar_cpu.sh 1`
cpu_bar_1=`"$SCRIPTDIR"/bar_cpu.sh 2`
cpu_bar_2=`"$SCRIPTDIR"/bar_cpu.sh 3`
cpu_bar_3=`"$SCRIPTDIR"/bar_cpu.sh 4`

mem_bar=`"$SCRIPTDIR"/bar_ram_lg.sh`

sda_root_bar=`"$SCRIPTDIR"/bar_disk.sh /dev/sda5`
sda_home_bar=`"$SCRIPTDIR"/bar_disk.sh /dev/sda6`
sdb_bar=`"$SCRIPTDIR"/bar_disk.sh /dev/sdb1`

(
    echo "^fg($highlight)System"
    echo " $kernel"
    echo " $packages   $uptime"
    echo " "
    echo " $cpu_bar_0"
    echo " $cpu_bar_1"
    echo " $cpu_bar_2"
    echo " $cpu_bar_3"
    echo " $cputemp"
    echo " "
    echo " $mem_bar"
    echo " ^i($ICONDIR/mem.xbm) ^fg($highlight)$ramused MB / $ramtotal MB"
    echo " "
    echo " $sda_root_bar"
    echo " $sda_home_bar"
    echo " $sdb_bar"
    sleep 5
) | dzen2 -fg "$foreground" -bg  "$background" -fn "$FONT" -x $XPOS -y $YPOS -w $WIDTH -l $LINES -h $HEIGHT -ta c -sa l -title-name $POPUP -e 'onstart=uncollapse;button1=exit;button3=exit'
