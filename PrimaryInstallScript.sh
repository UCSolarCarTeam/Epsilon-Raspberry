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

#install SimpleAmqpClient
git clone https://github.com/alanxz/SimpleAmqpClient /tmp/SimpleAmqpClient/
mkdir /tmp/SimpleAmqpClient/build
(cd /tmp/SimpleAmqpClient/build && cmake \
	--yes --force-yes \
	-DRabbitmqc_INCLUDE_DIR=../../rabbitmq-c/librabbitmq \
	-DRabbitmqc_LIBRARY=../../rabbitmq-c/build/librabbitmq ..)
(cd /tmp/SimpleAmqpClient/build make)
mkdir /usr/local/include/SimpleAmqpClient
cp *.so* /usr/local/lib/
cp ../src/SimpleAmqpClient/*.h /usr/local/include/SimpleAmqpClient
ldconfig -v

#install Epsilon-Hermes
git clone https://github.com/UCSolarCarTeam/Epsilon-Hermes.git /home/pi/Epsilon-Hermes/
(cd /home/pi/Epsilon-Hermes && cd ../ && mv ./Epsilon-Hermes ./src \
	&& mkdir Epsilon-Hermes \
	&& mv ./src ./Epsilon-Hermes/)
qmake /home/pi/Epsilon-Hermes/src/
make /home/pi/Epsilon-Hermes/src/
mv /home/pi/build/Epsilon-Hermes /opt/

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

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
