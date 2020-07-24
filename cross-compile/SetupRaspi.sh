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
        libxcb-xinerama0 \
        libgstreamer0.10-dev \
        gstreamer1.0-alsa \
        gstreamer1.0-doc \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-base-apps \
        gstreamer1.0-plugins-base-dbg \
        gstreamer1.0-plugins-base-doc \
        gstreamer1.0-tools \
        gstreamer1.0-x \
        libgstreamer1.0-0 \
        libgstreamer1.0-dev \
        gstreamer1.0-omx \
        gstreamer1.0-omx-rpi \
        gstreamer1.0-omx-rpi-config \
        gstreamer1.0-plugins-good \
        libgstreamer-plugins-base0.10-0  \
        libgstreamer-plugins-base0.10-dev \
        libgstreamer-plugins-base1.0-dev \
        gstreamer-tools \
        rabbitmq-server \

mkdir -p /usr/local/qt5pi
chown -R pi:pi /usr/local/qt5pi
chown -R pi:pi /usr/local/include
chown -R pi:pi /usr/local/lib

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

if ! grep "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/qt5pi/lib:/usr/local/lib" /home/pi/.bashrc; then
        echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/qt5pi:/usr/local/lib" >> /home/pi/.bashrc
fi

echo "Done!"