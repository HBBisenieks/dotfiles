#!/bin/bash

WALLPAPERS="/path/to/wallpapers"
ALIST=( `ls -w 1 $WALLPAPERS` )
RANGE=${#ALIST[*]}
SHOW=$(( $RANDOM % $RANGE ))

DISPLAY=:0 feh --bg-scale $WALLPAPERS/${ALIST[$SHOW]}
