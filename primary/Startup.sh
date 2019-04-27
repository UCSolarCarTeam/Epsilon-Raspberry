#!/bin/bash
if pgrep -l "Schulich" > /dev/null
then
    echo "Already Running"
else
    export DISPLAY=:0
    cd /home/pi/Documents/SolarCar/Epsilon-Domovoi && sudo -E ./domovoi.py primary
fi
