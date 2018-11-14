#!/bin/sh

cd /path/to/pianobar/.config/pianobar
ps -A | grep pianobar > /dev/null 2>&1

if [ "$?" -eq 0 ] ; then
	var=`cat nowplaying`
	echo "$var"
else
	echo ""
fi

exit 0
