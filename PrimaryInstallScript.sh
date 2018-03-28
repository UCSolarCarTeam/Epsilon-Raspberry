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
(cd /tmp/SimpleAmqpClient/build && make)
mkdir /usr/local/include/SimpleAmqpClient
cp *.so* /usr/local/lib/
cp ../src/SimpleAmqpClient/*.h /usr/local/include/SimpleAmqpClient
ldconfig -v

#install Epsilon-Hermes
git clone https://github.com/UCSolarCarTeam/Epsilon-Hermes.git /home/pi/Epsilon-Hermes/
(cd /home/pi/Epsilon-Hermes && cd ../ && mv ./Epsilon-Hermes ./src \
	&& mkdir Epsilon-Hermes \
	&& mv ./src ./Epsilon-Hermes/)
(cd /home/pi/Epsilon-Hermes/src && qmake && make)
mv /home/pi/Epsilon-Hermes/build/SchulichEpsilonHermes /opt/

#install google-test-suite
git clone https://github.com/google/googletest.git
(cd /home/pi/googletest/ && g++ -isystem googletest/include/ \
	-Igoogletest -isystem googlemock/include/ \
	-Igooglemock -pthread -c googletest/src/gtest-all.cc)
(cd googletest/ && g++ -isystem googletest/include/ \
	-Igoogletest -isystem googlemock/include/ \
	-Igooglemock -pthread -c googlemock/src/gmock-all.cc)
(cd /home/pi/googletest && ar -rv libmock.a gtest-all.o gmock-all.o)
mkdir -p /home/pi/Epsilon-Hermes/build/.lib
mv /home/pi/googletest/libmock /home/pi/Epsilon-Hermes/build/.lib
cp -r /home/pi/googletest/googlemock/include/gmock /usr/local/include
cp -r /home/pi/googletest/googletest/include/gtest /usr/local/include

#install BackupCamera
git clone https://github.com/UCSolarCarTeam/BackupCamera.git /home/pi/BackupCamera/
/home/pi/BackupCamera/Installer/MainInstaller.sh
/home/pi/BackupCamera/Installer/AutoBootSetup.sh
(cd /home/pi/BackupCamera && make)
tvservice -d edid
edidparser edid

#install Dashboard
git clone https://github.com/UCSolarCarTeam/Epsilon-Dashboard.git /home/pi/Epsilon-Dashboard/
/home/pi/Epsilon-Dashboard/EpsilonDashboardSetup.sh
qmake /home/pi/Epsilon-Dashboard/src/
(cd /home/pi/Epsilon-Dashboard/src/ make)
mv /home/pi/Epsilon-Dashboard/build/EpsilonDashboard /opt/

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
mv PrimaryDomovoi/domovoiStart /etc/init.d #move domovoiStart script to boot location
mv PrimaryDomovoi/race.txt /home/pi/Domovoi #move config files to Domovoi repo so domovoi script in domovoiStart knows them
mv PrimaryDomovoi/display.txt /home/pi/Domovoi
#once tests are complete, call reboot
