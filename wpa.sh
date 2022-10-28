#!/bin/bash
filename=${1}
n=1
after=".conf"

if [ -z $filename ]; then
	echo 'uasge ./wpa.sh <filename>'
	exit
fi

if [ ! -f "/usr/bin/wpa_passphrase" ]; then
	echo -e "\e[0;31mwpa_passphrase requried"
	exit
fi 

if [ -r $filename ]; then

	echo -e "\e[1;32mReading WiFi list from ${filename}"
	echo

	while read line; do
		ESSID="$(echo ${line} | awk -F: '{print $1}')"
		PSK="$(echo ${line} | awk -F: '{print $2}')"

		if [ ! -z ESSID ] && [ ! -z PSK ]; then
			wpa_passphrase $ESSID > $ESSID.conf $PSK
			if [ -f "${ESSID}${after}" ]; then
				echo -e "\e[1;33mCreated PSK-conf file '\e[0;32m${ESSID}${after}\e[1;33m'"
			else
				echo -e "\e[0;31mError wpa_passphrase in '${ESSID}${after}'"
			fi
		fi

		n=$((n+1));
	done < $filename
	
	echo
	echo -e "\e[1;35mwpa.sh Done, Thank you"

else
	echo -e "\e[0;31m${filename} not found"
fi
