#!/bin/bash
# /etc/init.d/domovoiStart.sh
### BEGIN INIT INFO
# Provides:				domovoiStart
# Required-Start:		$remote_fs $syslog
# Required-Stop:		$remote_fs $syslog
# Default-Start:		2 3 4 5
# Default-Stop:			0 1 6
# Short-Description:	Start domovoi upon boot
# Description:			Start domovoi upon boot
### END INIT INFO

#note, if can read the ip, can use conditional statement to run domovoi
(cd /home/pi/Epsilon-Domovoi && ./domovoi.py primary)
