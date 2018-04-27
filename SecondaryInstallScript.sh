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
(cd /home/pi/BackupCamera && make)
tvservice -d edid
edidparser edid

#install SimpleAmqpClient
git clone https://github.com/alanxz/SimpleAmqpClient /tmp/SimpleAmqpClient/
mkdir /tmp/SimpleAmqpClient/build
(cd /tmp/SimpleAmqpClient/build && cmake \
	--yes --force-yes \
	-DRabbitmqc_INCLUDE_DIR=../../rabbitmq-c/librabbitmq \
	-DRabbitmqc_LIBRARY=../../rabbitmq-c/build/librabbitmq ..)
(cd /tmp/SimpleAmqpClient/build && make)
mkdir /usr/local/include/SimpleAmqpClient
cp *.so* /usr/local/lib/
cp ../src/SimpleAmqpClient/*.h /usr/local/include/SimpleAmqpClient
ldconfig -v

#install Dashboard
git clone https://github.com/UCSolarCarTeam/Epsilon-Dashboard.git /home/pi/Epsilon-Dashboard/
/home/pi/Epsilon-Dashboard/EpsilonDashboardSetup.sh
(cd /home/pi/Epsilon-Dashboard/src/ && /home/pi/qt5/bin/qmake)
(cd /home/pi/Epsilon-Dashboard/src/ && make)
cp -r /home/pi/Epsilon-Dashboard/build/ /opt/SchulichEpsilonDashboard

#install Epsilon-Onboard-Media-Control
git clone https://github.com/UCSolarCarTeam/Epsilon-Onboard-Media-Control.git /home/pi/Epsilon-Onboard-Media-Control/
(cd /home/pi/Epsilon-Onboard-Media-Control/ && /home/pi/qt5/bin/qmake)
(cd /home/pi/Epsilon-Onboard-Media-Control/ && make)
cp -r /home/pi/build/ /opt/OnboardMediaControl

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
#patch -p0 < patchToSecondary	#update the PrimaryDirectory to the secondary directory
chmod 755 /home/pi/Domovoi/domovoi.py 	#make script executable
mv SecondaryDomovoi/domovoiStart.sh /etc/init.d #move domovoiStart script to boot location
chmod 755 /etc/init.d/domovoiStart.sh
update-rc.d domovoiStart.sh defaults	#register the script with run-levels
#mv PrimaryDomovoi/race.txt /home/pi/Domovoi 
mv SecondaryDomovoi/display.txt /home/pi/Domovoi #move config files to Domovoi repo so domovoi script in domovoiStart knows them
#once tests are complete, call reboot
