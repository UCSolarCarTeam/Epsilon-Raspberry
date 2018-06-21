#!/bin/bash
# Note - When using two screens, it acts as two logins, so the .profile is run twice
# Be careful to not accidentally get it to run domovoi twice. 
# First, check if Hermes or Dashboard is running
sleep 3

if pgrep -l "Epsilon" > /dev/null
then
    echo "1 An instance of Hermes or Dashboard is already running."
else
	#Sleep for a random time between 0 and 5 seconds
	sleep $[ ( $RANDOM % 5 )  + 1 ]s
	if pgrep -l "Epsilon" > /dev/null
	then
		echo "2 An instance of Hermes or Dashboard is already running."
    	else
    		(export DISPLAY=:0 && cd /home/pi/Desktop/Epsilon-Domovoi && sudo -E ./domovoi.py secondary)
		echo "1" >> /home/pi/test
	fi
fi
