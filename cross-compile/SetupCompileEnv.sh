#!/usr/bin/env bash

DEFAULT_RPI_ADDRESS=raspberrypi.local
DEFAULT_RPI_USER=pi

RPI_ADDRESS=$DEFAULT_RPI_ADDRESS
RPI_USER=$DEFAULT_RPI_USER

function printHelp() {
    echo "Options:"
    echo "-u Raspberry Pi Username (default: $DEFAULT_RPI_USER)"
    echo "-a Raspberry Pi Address (default: $DEFAULT_RPI_ADDRESS)"
}

while getopts "u:a:h" args
do
    case $args in
        u) # str1
            RPI_USER=$OPTARG
            ;;
        a) # str2
            RPI_ADDRESS=$OPTARG
            ;;
        h)
            printHelp
            exit 1
            ;;
        \?)
          printHelp
          exit 1
          ;;
        :)
          printHelp
          exit 1
    esac
done

echo "RPI_ADDRESS: $RPI_ADDRESS"
echo "RPI_USER: $RPI_USER"

echo "Checking internet connection..."
ping -q -c1 google.com > /dev/null

if [ $? -ne 0 ]; then
	echo "No Internet Connection...Aborting"
	exit 1
fi
echo "OK"

echo "Checking connection to $RPI_ADDRESS"
ping -q -c1 $RPI_ADDRESS > /dev/null
if [ $? -ne 0 ]; then
	echo "Cannot connect to Pi, aborting..."
	exit 1
fi
echo "OK"

echo "Creating Sysroot at ~/raspi"
mkdir -p ~/raspi
cd ~/raspi
if [ ! -d ~/raspi/tools ]; then
    git clone https://github.com/raspberrypi/tools
fi
mkdir -p sysroot sysroot/usr sysroot/opt

echo "Syncing with raspberry pi"
rsync -avz $RPI_USER@$RPI_ADDRESS:/lib sysroot
rsync -avz $RPI_USER@$RPI_ADDRESS:/usr/include sysroot/usr
rsync -avz $RPI_USER@$RPI_ADDRESS:/usr/lib sysroot/usr
rsync -avz $RPI_USER@$RPI_ADDRESS:/opt/vc sysroot/opt

if [ ! -f ~/raspi/qt-everywhere-src-5.12.5.tar.xz ]; then
    wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
fi
chmod +x sysroot-relativelinks.py
./sysroot-relativelinks.py sysroot


if [ ! -d ~/raspi/qt-everywhere-src-5.12.5 ]; then
    if [ ! -f ~/raspi/qt-everywhere-src-5.12.5.tar.xz ]; then
        echo "Downloading QT 5.12.5..."
        wget http://download.qt.io/official_releases/qt/5.12/5.12.5/single/qt-everywhere-src-5.12.5.tar.xz
    fi
    echo "Extracting Qt 5.12.5..."
    tar xvf ~/raspi/qt-everywhere-src-5.12.5.tar.xz
else
    echo "~/raspi/qt-everywhere-src-5.12.5 directory exists"
fi

echo "Configuring..."
(cd qt-everywhere-src-5.12.5 && ./configure \
    -release \
    -opengl es2 \
    -device linux-rasp-pi-g++ \
    -device-option CROSS_COMPILE=~/raspi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- \
    -sysroot ~/raspi/sysroot \
    -opensource \
    -confirm-license \
    -skip qtwayland \
    -skip qtlocation \
    -skip qtscript \
    -make libs \
    -prefix /usr/local/qt5pi \
    -extprefix ~/raspi/qt5pi \
    -hostprefix ~/raspi/qt5 \
    -no-use-gold-linker \
    -v \
    -no-gbm |& tee "output_configure.txt")

echo "Making QT, sit back and relax!"
(cd qt-everywhere-src-5.12.5 && make -j4 |& tee "output_make.txt")
(cd qt-everywhere-src-5.12.5 && make install -j4 |& tee "output_make_install.txt")

QMAKE=~/raspi/qt5/bin/qmake

echo "Making QT SerialPort"
(cd qt-everywhere-src-5.12.5/qtserialport && $QMAKE .)
(cd qt-everywhere-src-5.12.5/qtserialport && make -j4 |& tee "output_qtserialport_make.txt")
(cd qt-everywhere-src-5.12.5/qtserialport && make install -j4 |& tee "output_qtserialport_make_install.txt")

echo "Making QT Multimedia"
(cd qt-everywhere-src-5.12.5/qtmultimedia && $QMAKE .)
(cd qt-everywhere-src-5.12.5/qtmultimedia && make -j4 |& tee "output_qtmultimedia_make.txt")
(cd qt-everywhere-src-5.12.5/qtmultimedia && make install -j4 |& tee "output_qtmultimedia_make_install.txt")

echo "Deploying qt5pi to raspberry pi..."
rsync -avz qt5pi $RPI_USER@$RPI_ADDRESS:/usr/local

if [ ! -f ~/raspi/qt5/bin/qmake ]; then
    echo "qmake does not exist in ~/raspi/qt5/bin, please verify output logs in qt-everywhere-src-5.12.5."
else
    echo "Complete! qmake exists in ~/raspi/qt5/bin/"
fi