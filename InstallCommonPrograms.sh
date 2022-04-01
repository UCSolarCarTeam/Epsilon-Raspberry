#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "Please run as root user"
	exit 1
fi
#install BackupCamera
git clone https://github.com/UCSolarCarTeam/BackupCamera.git /home/pi/BackupCamera/
/home/pi/BackupCamera/Installer/MainInstaller.sh
(cd /home/pi/BackupCamera && make)
mkdir /opt/SchulichBackupCamera/ && cp /home/pi/BackupCamera/BackupCamera /opt/SchulichBackupCamera/