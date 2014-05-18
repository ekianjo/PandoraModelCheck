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
cpuspeed=$( printf "%.0f" $cpuspeed )

hardware=$(grep Hardware cat /proc/cpuinfo | awk '{print $3,$4,$5}')

if [ $ramsize -gt 256 ] && [ $var2 -gt 390 ]; then
	model=( "1Ghz Model (2012)" )
        defaultcpu=1000
        echo $cpuspeed
        if [[ $cpuspeed -gt 990 ]]; then
          if [[ $cpuspeed -lt 1010 ]]; then
              cpuspeed+=" Mhz (Default)"
          else
             cpuspeed+=" Mhz (Overclocked - Default is 1000 Mhz)"
          fi
        else
          cpuspeed+=" Mhz (Underclocked - Default is 1000 Mhz)"
        fi
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

uptime=$( uptime | awk '{print $3,$4}' )
uptime=(${$uptime//,/.}) 
# Displays the info with a super simple Zenity line.
#zenity --info --text "$(echo $message $message2 $var0)" --title "Pandora Model Check"

arrIN="Not recognized."

#checksumpart below
esver=$(cat /etc/powervr-esrev)
filetotest=$(find /usr/lib/ES$esver.0/libEGL*)
md5test=$(openssl md5 "$filetotest" | awk '{ print $2 }')
cd checksum
for d in *; do
  cd $d
  cd ES$esver
  echo $PWD
  fileref=$(find *EGLmd5)
  echo $fileref
  checksumcheck=$(basename "$fileref" .EGLmd5)
  echo "$checksumcheck"
  if [ "$checksumcheck" = "$md5test" ]; then
    echo "we have a winner"
    echo "$d"
    arrIN=(${d//_/ })
    echo $arrIN
    driverversion=$arrIN
    if [ "$driverversion" = "4.00.00.01" ]; then
      driverversion+=" (Default)"
    else
      driverversion+=" (Default is 4.00.00.01)"
    fi
     

    cd ..
    cd ..
    break
  fi
  cd ..
  cd ..
done
echo $PWD
cd ..
./yad --image=logo2.png --image-on-top --width=500 --height=400 --button=gtk-ok:1 --title "Pandora Model Check" --list --column="Component" --column="Value" "Hardware" "$hardware" "Model" "${model[@]}" "Processor" "$processor" "CPU Speed" "$cpuspeed" "RAM Size" "$ramsize" "Firmware" "$var" "GPU Driver" "$driverversion" "Linux Version" "$linuxversion" "User Name" "$(whoami)" "System Uptime" "$uptime"
