#!/bin/sh
if pgrep -l "Epsilon" > /dev/null
then
	echo "running"
else
	echo "Starting"
	(cd /home/pi/Documents/SolarCar/Epsilon-Domovoi && sudo -E ./domovoi.py secondary)
fi
