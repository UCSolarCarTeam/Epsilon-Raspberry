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

#install Epsilon-Onboard-Media-Control
git clone https://github.com/UCSolarCarTeam/Epsilon-Onboard-Media-Control.git /home/pi/Epsilon-Onboard-Media-Control/
(cd /home/pi/Epsilon-Onboard-Media-Control/ && /home/pi/qt5/bin/qmake)
(cd /home/pi/Epsilon-Onboard-Media-Control/ && make)
cp /home/pi/Epsilon-Dashboard/src/config.ini /home/pi/Epsilon-Dashboard/build
cp -r /home/pi/build/ /opt/OnboardMediaControl

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
chmod 755 /home/pi/Domovoi/domovoi.py 	#make script executable
cp secondary/domovoi/display.txt /home/pi/Domovoi #move config files to Domovoi repo so domovoi script in domovoiStart knows them
