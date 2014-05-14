#!/bin/bash

# get the firmware information
var=$(cat /etc/op-version | sed -n 4p)

# get linux version
linuxversion=$(cat /proc/version | awk '{print $3}')

linuxkernel=$(cat uname -r | awk '{print $2}')

defaultlang=$(set | egrep '^(LANG|LC_)' | awk '{print $1}')

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



# Displays the info with a super simple Zenity line.
#zenity --info --text "$(echo $message $message2 $var0)" --title "Pandora Model Check"

./yad --width=400 --height=300 --title "Pandora Model Check" --list --column="Component" --column="Value" "Firmware" "$var" "Linux Version" "$linuxversion" "Linux Kernel" "$linuxkernel" "System Language" "$defaultlang" "Processor" "$processor" "RAM Size" "$var3" "Pandora Model" "${model[@]}" "User Name" "$usershellname"
