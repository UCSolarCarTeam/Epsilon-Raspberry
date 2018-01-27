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

#install BackupCamera
git clone https://github.com/UCSolarCarTeam/BackupCamera.git /home/pi/BackupCamera/
/home/pi/BackupCamera/Installer/MainInstaller.sh
/home/pi/BackupCamera/Installer/AutoBootSetup.sh
tvservice -d edid
edidparser edid

#install Dashboard
git clone https://github.com/UCSolarCarTeam/Epsilon-Dashboard.git /home/pi/Epsilon-Dashboard/
/home/pi/Epsilon-Dashboard/EpsilonDashboardSetup.sh
qmake /home/pi/Epsilon-Dashboard/src/
make /home/pi/Epsilon-Dashboard/src/
mv /home/pi/build/Epsilon-Dashboard /opt/

#install Epsilon-Onboard-Media-Control
git clone https://github.com/UCSolarCarTeam/Epsilon-Onboard-Media-Control.git /home/pi/Epsilon-Onboard-Media-Control/
qmake /home/pi/Epsilon-Onboard-Media-Control/
make /home/pi/Epsilon-Onboard-Media-Control/
mv /home/pi/build/Epsilon-Onboard-Media-Control /opt/

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
