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

#install rabbitmq-c
git clone https://github.com/alanxz/rabbitmq-c /tmp/rabbitmq-c/
mkdir /tmp/rabbitmq-c/build
(cd /tmp/rabbitmq-c/build && cmake .. && cmake --build .)
cp /tmp/rabbitmq-c/build/librabbitmq/*.a /usr/local/lib/
cp /tmp/rabbitmq-c/build/librabbitmq/*.so* /usr/local/lib/

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

#install google-test-suite
git clone https://github.com/google/googletest.git /home/pi/googletest
(cd /home/pi/googletest/ && g++ -isystem googletest/include/ \
	-Igoogletest -isystem googlemock/include/ \
	-Igooglemock -pthread -c googletest/src/gtest-all.cc)
(cd /home/pi/googletest/ && g++ -isystem googletest/include/ \
	-Igoogletest -isystem googlemock/include/ \
	-Igooglemock -pthread -c googlemock/src/gmock-all.cc)
(cd /home/pi/googletest && ar -rv libgmock.a gtest-all.o gmock-all.o)
cp -r /home/pi/googletest/googlemock/include/gmock /usr/local/include
cp -r /home/pi/googletest/googletest/include/gtest /usr/local/include

#install Epsilon-Hermes
git clone https://github.com/UCSolarCarTeam/Epsilon-Hermes.git /home/pi/Epsilon-Hermes/
(cd /home/pi/Epsilon-Hermes && cd ../ && mv ./Epsilon-Hermes ./src \
	&& mkdir Epsilon-Hermes \
	&& mv ./src ./Epsilon-Hermes/)
mkdir -p /home/pi/Epsilon-Hermes/build/.lib
cp /home/pi/googletest/libgmock.a /home/pi/Epsilon-Hermes/build/.lib
(cd /home/pi/Epsilon-Hermes/src && /home/pi/qt5/bin/qmake && make)
cp -r /home/pi/Epsilon-Hermes/build/ /opt/SchulichEpsilonHermes

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
(cd /home/pi/Epsilon-Dashboard/src/ && /home/pi/qt5/bin/qmake)
(cd /home/pi/Epsilon-Dashboard/src/ && make)
cp -r /home/pi/Epsilon-Dashboard/build/ /opt/SchulichEpsilonDashboard

#install Domovoi
git clone https://github.com/UCSolarCarTeam/Epsilon-Domovoi.git /home/pi/Domovoi/
chmod 755 /home/pi/Domovoi/domovoi.py 	#make script executable
mv PrimaryDomovoi/domovoiStart.sh /etc/init.d #move domovoiStart script to boot location
chmod 755 /etc/init.d/domovoiStart.sh
update-rc.d domovoiStart.sh defaults	#register the script with run-levels
mv PrimaryDomovoi/race.txt /home/pi/Domovoi #move config files to Domovoi repo so domovoi script in domovoiStart knows them
mv PrimaryDomovoi/display.txt /home/pi/Domovoi
#once tests are complete, call reboot
