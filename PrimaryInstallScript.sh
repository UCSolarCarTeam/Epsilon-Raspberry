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

#install hermes
cd /
git clone https://github.com/UCSolarCarTeam/Epsilon-Hermes.git
cd Epsilon-Hermes
cd ../ && mv ./Epsilon-Hermes ./src && mkdir Epsilon-Hermes && mv ./src ./Epsilon-Hermes/

#install Backup Camera
cd ~
git clone https://github.com/UCSolarCarTeam/BackupCamera.git
cd BackupCamera/Installer
./MainInstaller.sh
./AutoBootSetup.sh
tvservice -d edid
edidparser edid
