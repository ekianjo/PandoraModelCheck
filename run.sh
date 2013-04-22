#!/bin/bash

# get the firmware information
var=$(cat /etc/op-version | sed -n 4p)
var0="Your current firmware is $var."

# get the max CPU syspeed to confirm whether it's a old OMAP or a 1Ghz OMAP.
var2=$(cat /proc/pandora/sys_mhz_max)
if [ "$var2" = "332" ]; then
	message2="It has a 600Mhz OMAP processor."
else
	message2="It has a 1Ghz OMAP processor."
fi

# get the total RAM size. 
var3=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ramsize=$((var3/1024))

if [ $ramsize -lt 500 ]; then
	message="Your Pandora is an Original CC Model, equipped with 256Mb of RAM."
else
	message="Your Pandora is a Rebirth Edition, equipped with 512Mb of RAM."
fi

# Displays the info with a super simple Zenity line.
zenity --info --text "$(echo $message $message2 $var0)" --title "Pandora Model Check"
