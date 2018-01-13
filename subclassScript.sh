#!/bin/bash

/home/pi/qt5/qtbase/configure -v -opengl es2 \
	-device linux-rasp-pi-g''+ \
	-device-option CROSS_COMPILE=/usr/bin/ \
	-opensource -confirm-license -optimized-qmake -reduce-exports -release -qt-pcre -make libs \
	-prefix /usr/local/qt5 &> output
make |& tee "output.txt"
make install |& tee "output_make_install.txt"
(cd /home/pi/qt5/qtmultimedia && qmake && make && make install)
(cd /home/pi/qt5/qtsvg && qmake && make && make install)
(cd /home/pi/qt5/qtwebkit && qmake && make && make install)
(cd /home/pi/qt5/qttools && qmake && make && make install)
(cd /home/pi/qt5/qtserialport && qmake && make && make install)
