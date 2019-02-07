#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "Please run as root user"
	exit 1
fi
#install BackupCamera
git clone https://github.com/UCSolarCarTeam/BackupCamera.git /home/pi/BackupCamera/
/home/pi/BackupCamera/Installer/MainInstaller.sh
/home/pi/BackupCamera/Installer/AutoBootSetup.sh
(cd /home/pi/BackupCamera && make)
mkdir /opt/SchulichBackupCamera/ && cp /home/pi/BackupCamera/BackupCamera /opt/SchulichBackupCamera/

#install Dashboard
git clone https://github.com/UCSolarCarTeam/Epsilon-Dashboard.git /home/pi/Epsilon-Dashboard/
/home/pi/Epsilon-Dashboard/EpsilonDashboardSetup.sh
(cd /home/pi/Epsilon-Dashboard/src/ && /home/pi/qt5/bin/qmake)
(cd /home/pi/Epsilon-Dashboard/src/ && make)
mv /home/pi/Epsilon-Dashboard/src/config.ini /home/pi/Epsilon-Dashboard/build
cp -r /home/pi/Epsilon-Dashboard/build/ /opt/SchulichEpsilonDashboard