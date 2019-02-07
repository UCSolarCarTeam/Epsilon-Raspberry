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

git clone https://github.com/UCSolarCarTeam/Development-Resources.git /tmp/Development-Resources/
(
	cd /tmp/Development-Resources/InstallScripts 
	&& ./rabbitmq-setup.sh
	&& ./googletest-setup.sh
)

../InstallCommonPrograms.sh

#install Epsilon-Hermes
git clone https://github.com/UCSolarCarTeam/Epsilon-Hermes.git /home/pi/Epsilon-Hermes/
(cd /home/pi/Epsilon-Hermes && cd ../ && mv ./Epsilon-Hermes ./src \
	&& mkdir Epsilon-Hermes \
	&& mv ./src ./Epsilon-Hermes/)
mkdir -p /home/pi/Epsilon-Hermes/build/.lib
cp /usr/local/lib/libgmock.a /home/pi/Epsilon-Hermes/build/.lib
(cd /home/pi/Epsilon-Hermes/src && /home/pi/qt5/bin/qmake && make check)
cp /home/pi/Epsilon-Hermes/src/config.ini /home/pi/Epsilon-Hermes/build
mkdir /home/pi/Epsilon-Hermes/build/log
cp -r /home/pi/Epsilon-Hermes/build/ /opt/SchulichEpsilonHermes

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
chmod 755 /home/pi/Domovoi/domovoi.py 	#make script executable
cp primary/domovoi/race.txt /home/pi/Domovoi
cp primary/domovoi/display.txt /home/pi/Domovoi
