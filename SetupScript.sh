#!/bin/bash

if [ $USER -ne "root"]
	then
	echo "Permission Denied"
	exit 1
fi
#base script to fresh install systems onto base image for raspberry pi

#check internet connection
ping -q -c3 google.com > /dev/null

if [ $? -ne 0 ]
then
	echo "No Internet Connection...Aborting"
	exit 1
fi

#configure displays
cd /opt/
git clone https://github.com/UCSolarCarTeam/Epsilon-Raspberry.git
cd Epsilon-Raspberry/primary/
cp xorg.conf /etc/X11/
cp config.txt /boot/
#install rabbit-mq

echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list && sudo apt-get update && sudo apt-get install rabbitmq-server
sudo apt-get install cmake libboost-dev openssl libssl-dev libblkid-dev e2fslibs-dev libboost-all-dev libaudit-dev software-properties-common build-essential mesa-common-dev libgl1-mesa-dev

cd /tmp/
if ls /usr/local/lib/librabbitmq.* 1> /dev/null 2>&1 ;
then
echo "Rabbitmq already setup"
else
git clone https://github.com/alanxz/rabbitmq-c
mkdir rabbitmq-c/build && cd rabbitmq-c/build
cmake ..
cmake --build .
cp librabbitmq/*.a /usr/local/lib/
cp librabbitmq/*.so* /usr/local/lib/
fi

#begin QT install
apt-get update
apt-get --yes upgrade
apt-get install --yes libfontconfig1-dev libdbus-1-dev libfreetype6-dev libudev-dev libicu-dev libsqlite3-dev
libxslt1-dev libssl-dev libasound2-dev libavcodec-dev libavformat-dev libswscale-dev libgstreamer0.10-dev
libgstreamer-plugins-base0.10-dev gstreamer-tools gstreamer0.10-plugins-good gstreamer0.10-plugins-bad
libraspberrypi-dev libpulse-dev libx11-dev libglib2.0-dev libcups2-dev freetds-dev libsqlite0-dev libpq-dev
libiodbc2-dev libmysqlclient-dev firebird-dev libpng12-dev libjpeg9-dev libgst-dev libxext-dev libxcb1 libxcb1-dev
libx11-xcb1 libx11-xcb-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 libxcb-image0-dev libxcb-shm0
libxcb-shm0-dev libxcb-icccm4 libxcb-icccm4-dev libxcb-sync1 libxcb-sync-dev libxcb-render-util0
libxcb-render-util0-dev libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-glx0-dev
libxi-dev libdrm-dev libssl-dev libxcb-xinerama0 libxcb-xinerama0-dev

mkdir ~/opt
cd ~/opt
git clone git://code.qt.io/qt/qt5.git
cd ~/Epsilon-Raspberry
sudo mv fix-initrepo.patch ~/opt
cd qt5
git checkout v5.5.1
cd ..
patch -Np1 -d qt5 < fix-initrepo.patch
cd qt5
perl init-repository -f
cd ~/Epsilon-Raspberry
sudo mv QT_CFLAGS_DBUS.patch ~/opt/qt5
cd ~/opt/qt5
patch -Np1 -d qtbase < QT_CFLAGS_DBUS.patch
cd qtbase
./configure -v -opengl es2 -device linux-rasp-pi-g''+ -device-option CROSS_COMPILE=/usr/bin/ -opensource 
-confirm-license -optimized-qmake -reduce-exports -release -qt-pcre -make libs -prefix /usr/local/qt5 &> output
make |& tee "output.txt"
sudo make install |& tee "output_make_install.txt"
cd ~/opt/qt5/qtmultimedia
qmake
make
make install
