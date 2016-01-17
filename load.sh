#!/bin/bash

drive=

echo "WARNING: Misuse of this script can cause your OS not to boot anymore. BE CAREFUL!"

if [ ! -z `echo "$1" | grep [hs]d[a-z]$` ]
then
	drive="$1"
else
	j=1
	echo "Choose one of the following drives to load OS/4 to:"
	drives="$(ls /dev | grep [hs]d[a-z]$)"
	for i in $drives
	do
		echo -n "$i"
		if [ "$i" = "sda" ]
		then
			echo -n " (probably not this one)"
		fi
		echo " [$j]"
		j=`expr $j + 1`
	done
	echo -n "Enter the number of the drive you want to load it on or CTRL-C to back out: "
	read j

	drive=`echo $drives | cut -f $j -d ' '`
	ok="n"
	echo -n "Load OS/4 on to $drive? WARNING: This will make any previous OS cease to boot! [y/n]: "
	read ok
	if [ "$ok" = "y" ]
	then
		dd if=os4.bin of=/dev/$drive bs=446 count=1
	fi
fi

