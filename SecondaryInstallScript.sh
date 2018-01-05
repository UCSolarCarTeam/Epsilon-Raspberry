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
git clone https://github.com/UCSolarCarTeam/BackupCamera.git /opt/
/opt/BackupCamera/Installer/MainInstaller.sh
/opt/BackupCamera/Installer/AutoBootSetup.sh
tvservice -d edid
edidparser edid

#install Dashboard
git clone https://github.com/UCSolarCarTeam/Epsilon-Dashboard.git /opt/
/opt/Epsilon-Dashboard/EpsilonDashboardSetup.sh

#install Epsilon-Onboard-Media-Control
git clone https://github.com/UCSolarCarTeam/Epsilon-Onboard-Media-Control.git /opt/
qmake /opt/Epsilon-Onboard-Media-Control/
make /opt/Epsilon-Onboard-Media-Control/
/opt/build/OnBoardMediaControl

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /opt/

