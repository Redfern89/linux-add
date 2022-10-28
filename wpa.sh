#!/bin/bash
filename=${1}
n=1

if [ -z $filename ]; then
	echo 'uasge ./wpa.sh [filename]'
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
			if [ -f "${ESSID}.conf" ]; then
				echo -e "\e[1;33mCreated PSK-conf file '${ESSID}.conf'"
			else
				echo -e "\e[0;31mError wpa_passphrase in '${ESSID}.conf'"
			fi
		fi

		n=$((n+1));
	done < $filename
	
	echo
	echo -e "\e[1;35mDone"

else
	echo -e "\e[0;31m${filename} not found"
fi
