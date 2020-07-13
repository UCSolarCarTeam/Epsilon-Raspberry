#!/usr/bin/env bash

COMMAND="/opt/SchulichBackupCamera/BackupCamera"
ARGS="10 0 800 480 1024 768"

SECONDARYPI_ADDRESS="google.com"

ping -q -c1 $SECONDARYPI_ADDRESS > /dev/null

if [ $? -ne 0 ]; then
	echo "Cannot reach other pi"
	($COMMAND $ARGS)
fi

