#!/bin/bash
# Note - When using two screens, it acts as two logins, so the .profile is run twice
# Be careful to not accidentally get it to run domovoi twice. 
# First, check if Hermes or Dashboard is running
if pgrep -l "Epsilon" > /dev/null
	then
	    echo "An instance of Hermes or Dashboard is already running."
	else
		#Sleep for a random time between 0 and 5 seconds
		sleep 4s
		if pgrep -l "Epsilon" > /dev/null
			then
				echo "An instance of Hermes or Dashboard is already running."
	    	else
	    		rabbitmqctl start_app
	    		(export DISPLAY=:0 && cd /home/pi/Desktop/Epsilon-Domovoi && sudo -E ./domovoi.py secondary)
	    fi
fi
