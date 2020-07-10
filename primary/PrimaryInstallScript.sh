#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "Please run as root user"
	exit 1
fi

ping -q -c1 google.com > /dev/null
 
if [ $? -ne 0 ]; then
	echo "No Internet Connection...Aborting"
	exit 1
fi

../InstallCommonPrograms.sh

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
chmod 755 /home/pi/Domovoi/domovoi.py 	#make script executable
cp primary/domovoi/race.txt /home/pi/Domovoi
cp primary/domovoi/display.txt /home/pi/Domovoi
