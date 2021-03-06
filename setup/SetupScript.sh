#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "Please run as root user"
	exit 1
fi
#base script to fresh install systems onto base image for raspberry pi

#check internet connection
ping -q -c1 google.com > /dev/null

if [ $? -ne 0 ]; then
	echo "No Internet Connection...Aborting"
	exit 1
fi

#configure displays
git clone https://github.com/UCSolarCarTeam/Epsilon-Raspberry.git /opt/Epsilon-Raspberry/
cp /opt/Epsilon-Raspberry/primary/xorg.conf /etc/X11/ 
cp /opt/Epsilon-Raspberry/primary/config.txt /boot/

#Install rabbitmq & googletest
git clone https://github.com/UCSolarCarTeam/Development-Resources.git /tmp/Development-Resources/
(
	cd /tmp/Development-Resources/InstallScripts 
	&& ./rabbitmq-setup.sh
	&& ./googletest-setup.sh
)

#begin QT install
apt-get -y --force-yes upgrade
apt-get build-dep qt4-x11
apt-get build-dep libqt5gui5
apt-get install -y --force-yes -qq \
	libfontconfig1-dev \
	libdbus-1-dev \
	libfreetype6-dev \
	libudev-dev \
	libinput-dev \
	cmake \
	libboost-dev \
	openssl \
	libssl-dev \
	libblkid-dev \
	e2fslibs-dev \
	libboost-all-dev \
	libaudit-dev \
	software-properties-common \
	build-essential \
	mesa-common-dev \
	libgl1-mesa-dev
	libts-dev \
	libicu-dev \
	libsqlite3-dev \
	libxslt1-dev \
	libssl-dev \
	libasound2-dev \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	libgstreamer0.10-dev \
	libgstreamer-plugins-base0.10-dev \
	gstreamer-tools \
	gstreamer0.10-plugins-good gstreamer0.10-plugins-base gstreamer0.10-plugins-ugly \
	libraspberrypi-dev \
	libpulse-dev \
	libx11-dev \
	libglib2.0-dev \
	libcups2-dev \
	freetds-dev \
	libsqlite0-dev \
	libpq-dev \
	libiodbc2-dev \
	default-libmysqlclient-dev \
	firebird-dev \
	libpng12-dev \
	libjpeg9-dev \
	libgst-dev \
	libxext-dev \
	libxcb1 \
	libxcb1-dev \
	libx11-xcb1 \
	libx11-xcb-dev \
	libxcb-keysyms1 \
	libxcb-keysyms1-dev \
	libxcb-image0 \
	libxcb-image0-dev \
	libxcb-shm0 \
	libxcb-shm0-dev \
	libxcb-icccm4 \
	libxcb-icccm4-dev \
	libxcb-sync1 \
	libxcb-sync-dev \
	libxcb-render-util0 \
	libxcb-render-util0-dev \
	libxcb-xfixes0-dev \
	libxrender-dev \
	libxcb-shape0-dev \
	libxcb-randr0-dev \
	libxcb-glx0-dev \
	libxi-dev \
	libdrm-dev \
	libssl-dev \
	libxcb-xinerama0 \
	libxcb-xinerama0-dev
git clone git://code.qt.io/qt/qt5.git /home/pi/qt5
cp /opt/Epsilon-Raspberry/setup/fix-init.patch /home/pi/qt5
(cd /home/pi/qt5 && git checkout v5.5.1)
(cd /home/pi/qt5 && patch -Np1 -d . < fix-init.patch)
(cd /home/pi/qt5 && perl init-repository -f)
cp /opt/Epsilon-Raspberry/setup/QT_CFLAGS_DBUS.patch /home/pi/qt5
(cd /home/pi/qt5 && patch -Np1 -d qtbase < QT_CFLAGS_DBUS.patch)
(cd /home/pi/qt5/qtbase && ./configure \
	-no-use-gold-linker \
	-v -opengl es2 \
	-qt-xcb \
	-no-pch \
	-device linux-rasp-pi-g''+ \
	-device-option CROSS_COMPILE=/usr/bin/ \
	-opensource -confirm-license -optimized-qmake -reduce-exports -release -qt-pcre -make libs \
	-prefix /home/pi/qt5 |& tee "output_configure.txt")
(cd /home/pi/qt5/qtbase && make |& tee "output_make.txt")
(cd /home/pi/qt5/qtbase && make install |& tee "output_make_install.txt")
mv /usr/bin/qmake /usr/bin/qmake.bak
ln -s /home/pi/qt5/bin/qmake /usr/bin/qmake
(cd /home/pi/qt5/qtmultimedia && /home/pi/qt5/bin/qmake && make && make install)
(cd /home/pi/qt5/qtsvg && /home/pi/qt5/bin/qmake && make && make install)
(cd /home/pi/qt5/qtwebkit && /home/pi/qt5/bin/qmake && make && make install)
(cd /home/pi/qt5/qttools && /home/pi/qt5/bin/qmake && make && make install)
(cd /home/pi/qt5/qtserialport && /home/pi/qt5/bin/qmake && make && make install)

#update Path's with Qt files
echo 'export PATH=$PATH:/usr/local/Qt-5.5.1/bin' >> /home/pi/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/Qt-5.5.1/lib:/usr/local/lib' >> /home/pi/.bashrc
echo 'export QT_SELECT=qt55' >> /home/pi/.bashrc
source ~/.bashrc
