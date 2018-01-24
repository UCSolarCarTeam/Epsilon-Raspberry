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

#install Epsilon-Hermes
git clone https://github.com/UCSolarCarTeam/Epsilon-Hermes.git /opt/Epsilon-Hermes/
(cd /opt/Epsilon-Hermes && cd ../ && mv ./Epsilon-Hermes ./src
mkdir Epsilon-Hermes
mv ./src ./Epsilon-Hermes/)
qmake /opt/Epsilon-Hermes/
make /opt/Epsilon-Hermes/

git clone https://github.com/alanxz/SimpleAmqpClient /tmp/SimpleAmqpClient/
mkdir /tmp/SimpleAmqpClient/build
(cd /tmp/SimpleAmqpClient/build && cmake \
	--yes --force \
	-DRabbitmqc_INCLUDE_DIR=../../rabbitmq-c/librabbitmq \
	-DRabbitmqc_LIBRARY=../../rabbitmq-c/build/librabbitmq ..)
(cd /tmp/SimpleAmqpClient/build make)
mkdir /usr/local/include/SimpleAmqpClient
cp *.so* /usr/local/lib/
cp ../src/SimpleAmqpClient/*.h /usr/local/include/SimpleAmqpClient

#install BackupCamera
git clone https://github.com/UCSolarCarTeam/BackupCamera.git /opt/BackupCamera/
/opt/BackupCamera/Installer/MainInstaller.sh
/opt/BackupCamera/Installer/AutoBootSetup.sh
tvservice -d edid
edidparser edid

#install Dashboard
git clone https://github.com/UCSolarCarTeam/Epsilon-Dashboard.git /opt/Epsilon-Dashboard/
/opt/Epsilon-Dashboard/EpsilonDashboardSetup.sh
qmake /opt/Epsilon-Dashboard/src/
make /opt/Epsilon-Dashboard/src/

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /opt/Domovoi/
