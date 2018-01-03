#!/bin/bash

if [ $USER -ne "root"]
 	then
 	echo "Permission Denied"
 	exit 1
fi

ping -q -c3 google.com > /dev/null
 
if [ $? -ne 0 ]
then
	echo "No Internet Connection...Aborting"
	exit 1
fi

#install Backup Camera
cd ~
git clone https://github.com/UCSolarCarTeam/BackupCamera.git
cd BackupCamera/Installer
./MainInstaller.sh
./AutoBootSetup.sh
tvservice -d edid 
edidparser edid
#patch file likely needed to be created to completely configure Hermes

#install Dashboard
cd ~
git clone https://github.com/UCSolarCarTeam/Epsilon-Dashboard.git
cd Epsilon-Dashboard
./EpsilonDashboardSetup.sh

#install music-player
cd ~
git clone https://github.com/UCSolarCarTeam/Epsilon-Onboard-Media-Control.git

#install Domovoi
cd ~
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git
