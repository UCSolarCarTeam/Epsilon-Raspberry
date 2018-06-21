#!/bin/bash
sleep 5
if pgrep -l "Schulich" > /dev/null
then
    echo "Already Running"
else
    (export DISPLAY=:0 && cd /home/pi/Desktop/Epsilon-Domovoi && sudo -E ./domovoi.py secondary)
fi
