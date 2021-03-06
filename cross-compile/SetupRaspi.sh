#!/usr/bin/env bash

if [ $EUID -ne 0 ]; then
	echo "Please run as root user"
	exit 1
fi

echo "Checking internet connection..."
ping -q -c1 google.com > /dev/null

if [ $? -ne 0 ]; then
	echo "No Internet Connection...Aborting"
	exit 1
fi
echo "OK"

apt-get update
apt-get build-dep qt4-x11 -y
apt-get build-dep libqt5gui5 -y
apt-get install -y \
        libudev-dev \
        libinput-dev \
        libts-dev \
        libxcb-xinerama0-dev \
        libxcb-xinerama0

mkdir -p /usr/local/qt5pi
chown pi:pi /usr/local/qt5pi

# Later versions of raspbian use a differently named EGL and GLES libraries
# This will add links to point to the correct libraries in /opt/vc/lib/
# So qmake builds with the correct libraries

echo "Getting current EGL & GLESv2 libraries"
LIBEGL_LIBRARY=$(ls -1 /usr/lib/arm-linux-gnueabihf/libEGL.so.1.*.*)
echo "LIBEGL_LIBRARY: $LIBEGL_LIBRARY"
LIBGLES_LIBRARY=$(ls -1 /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.*.*)
echo "LIBGLES_LIBRARY: $LIBGLES_LIBRARY"

echo "Moving original files to backup folder"
mkdir -p /usr/lib/arm-linux-gnueabihf/backup
mv $LIBEGL_LIBRARY /usr/lib/arm-linux-gnueabihf/backup
mv $LIBGLES_LIBRARY /usr/lib/arm-linux-gnueabihf/backup

echo "Making symlinks"
ln -s /opt/vc/lib/libEGL.so $LIBEGL_LIBRARY
ln -s /opt/vc/lib/libGLESv2.so $LIBGLES_LIBRARY

ln -s /opt/vc/lib/libEGL.so /opt/vc/lib/libEGL.so.1
ln -s /opt/vc/lib/libGLESv2.so /opt/vc/lib/libGLESv2.so.2

echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt5pi/lib' >> /home/pi/.bashrc
echo "Done!"