#!/usr/bin/env bash

COMMAND="/opt/SchulichEpsilonDashboard/EpsilonDashboard"
ARGS="--platform xcb"

SECONDARYPI_ADDRESS="google.com"

ping -q -c1 $SECONDARYPI_ADDRESS > /dev/null

if [ $? -ne 0 ]; then
	echo "Cannot reah other pi"
	ARGS="-r --platform xcb"
fi

($COMMAND $ARGS)
