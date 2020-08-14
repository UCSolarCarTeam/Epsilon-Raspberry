#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "Please run as root user"
	exit 1
fi
#base script to fresh install systems onto base image for raspberry pi

#check internet connection
ping -q -c1 google.com > /dev/null

if [ $? -ne 0 ]; then
	echo "No Internet Connection...Aborting"
	exit 1
fi

#configure displays
git clone https://github.com/UCSolarCarTeam/Epsilon-Raspberry.git /opt/Epsilon-Raspberry/
cp /opt/Epsilon-Raspberry/primary/xorg.conf /etc/X11/ 
cp /opt/Epsilon-Raspberry/primary/config.txt /boot/

# Setup env for QT cross compilation
(cd /opt/Epsilon-Raspberry/cross-compile/ && ./SetupRaspi.sh)
