#!/bin/bash

# create variables
while read L; do
	k="`echo "$L" | cut -d '=' -f 1`"
	v="`echo "$L" | cut -d '=' -f 2`"
	export "$k=$v"
done < <(grep -e '^\(title\|artist\|album\|stationName\|songStationName\|pRet\|pRetStr\|wRet\|wRetStr\|songDuration\|songPlayed\|rating\|coverArt\|stationCount\|station[0-9]*\)=' /dev/stdin) # don't overwrite $1...

case "$1" in
	songstart)
#		echo 'naughty.notify({title = "pianobar", text = "Now playing: ' "$title" ' by ' "$artist" '"})' | awesome-client -

#		echo "$title -- $artist" > "${XDG_HOME_CONFIG:-${HOME}/.config}/pianobar/nowplaying"

		if [ "$rating" -eq 1 ]
		then
			echo "'$title' by '$artist' on '$album' - <3" > /path/to/pianobar/.config/pianobar/nowplaying
#			kdialog --title pianobar --passivepopup "'$title' by '$artist' on '$album' - LOVED" 10
		else
			echo "'$title' by '$artist' on '$album'" > /path/to/pianobar/.config/pianobar/nowplaying
#			kdialog --title pianobar --passivepopup "'$title' by '$artist' on '$album'" 10
		fi
#		# show an OS X notification
#		osascript -e "display notification \"$album\" with title \"$title\" subtitle \"$artist\""
#		# or whatever you like...
		;;
	*)
#		if [ "$pRet" -ne 1 ]; then
#			echo "naughty.notify({title = \"pianobar\", text = \"$1 failed: $pRetStr\"})" | awesome-client -
#			kdialog --title pianobar --passivepopup "$1 failed: $pRetStr"
#		elif [ "$wRet" -ne 1 ]; then
#			echo "naughty.notify({title = \"pianobar\", text = \"$1 failed: Network error: $wRetStr\"})" | awesome-client -
#			kdialog --title pianobar --passivepopup "$1 failed: Network error: $wRetStr"
#		fi
		echo "" > /path/to/pianobar/.config/pianobar/nowplaying
		;;
esac
