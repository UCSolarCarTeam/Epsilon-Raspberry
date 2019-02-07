#!/bin/sh
if pgrep -l "Epsilon" > /dev/null
then
	echo "Programs are already running"
else
	sleep 5
	echo "Starting Programs"
	(cd /home/pi/Desktop/Epsilon-Domovoi && sudo ./domovoi.py secondary)
fi
