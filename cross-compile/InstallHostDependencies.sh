#!/usr/bin/env bash

if [ $EUID -ne 0 ]; then
	echo "Please run as root user"
	exit 1
fi

apt install -y \
	build-essential \
	python \
	gcc-multilib \

if [ ! -d /opt/raspi/tools ]; then
	mkdir -p /opt/raspi/
	cd /opt/raspi
    git clone https://github.com/raspberrypi/tools
fi