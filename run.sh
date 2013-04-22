#!/bin/bash

echo "caca"
var=$(cat /etc/op-version | sed -n 4p)
var0="Your current firmware is $var."
var2=$(cat /proc/pandora/sys_mhz_max)

if [ "$var2" = "332" ]; then
	message2="It has a 600Mhz OMAP processor."
else
	message2="It has a 1Ghz OMAP processor."
fi

var3=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ramsize=$((var3/1024))

if [ $ramsize -lt 500 ]; then
	message="Your Pandora is an Original CC Model, equipped with 256Mb of RAM."
else
	message="Your Pandora is a Rebirth Edition, equipped with 512Mb of RAM."
fi

zenity --info --text "$(echo $message $message2 $var0)" --title "Pandora Model Check"
