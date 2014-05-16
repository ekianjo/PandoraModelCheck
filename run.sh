#!/bin/bash

# get the firmware information
var=$(cat /etc/op-version | sed -n 4p)

# get linux version
linuxversion=$(cat /proc/version | awk '{print $3}')

usershellname=&(ps -p $$ | tail -1 | awk '{ print $4 }')

var0="The latest firmware reflashed on your Pandora is $var (running Linux $linuxversion)."

# get processor model info
processor=$(cat /proc/cpuinfo | sed -n 1p | awk '{print $3, $4, $5, $6, $7}')

# get the max CPU syspeed to confirm whether it's a old OMAP or a 1Ghz OMAP.
var2=$(cat /proc/pandora/sys_mhz_max)
if [ $var2 -gt 390 ]; then
	message2="It has a 1Ghz processor ($processor)."
else
	message2="It has a 600Mhz processor ($processor)."
fi

# get the total RAM size. 
var3=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ramsize=$((var3/1024))

cpuspeed=$(grep BogoMIPS cat /proc/cpuinfo | awk '{print $3}')
cpuspeed+=" Mhz"

hardware=$(grep Hardware cat /proc/cpuinfo | awk '{print $3,$4,$5}')

if [ $ramsize -gt 256 ] && [ $var2 -gt 390 ]; then
	model=( "1Ghz Model (2012)" )
else
if [ $ramsize -gt 256 ] && [ $var2 -lt 390 ]; then
	model=( "Rebirth Model (2011)" )
else
if [ $ramsize -lt 256 ] && [ $var2 -lt 390 ]; then
	model=( "CC Model (2008)" )
fi
fi
fi	

ramsize="$ramsize Mb"

uptime=$( uptime | awk '{print $1}' )
uptime="$uptime hours/mins/secs" 
# Displays the info with a super simple Zenity line.
#zenity --info --text "$(echo $message $message2 $var0)" --title "Pandora Model Check"

./yad --width=550 --height=330 --button=gtk-ok:1 --title "Pandora Model Check" --list --column="Component" --column="Value" "Hardware" "$hardware" "Model" "${model[@]}" "Processor" "$processor" "CPU Speed" "$cpuspeed" "RAM Size" "$ramsize" "Firmware" "$var" "Linux Version" "$linuxversion" "User Name" "$(whoami)" "System Uptime" "$uptime"
