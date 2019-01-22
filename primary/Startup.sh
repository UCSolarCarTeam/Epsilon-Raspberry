#!/bin/bash
# Note - When using two screens, it acts as two logins, so the .profile is run twice
# Be careful to not accidentally get it to run domovoi twice. 
# First, check if Hermes or Dashboard is running
sleep 6
start=true
	if pgrep -l "Epsilon" > /dev/null
	then
    		echo "An instance of Hermes or Dashboard is already running."
		start=false
	fi
if [ $start = true ];
then
echo "Starting programs"
(export DISPLAY=:0 && cd /home/pi/Desktop/Epsilon-Domovoi && sudo -E ./domovoi.py primary)
fi
