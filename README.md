# Epsilon-Raspberry

This repo contains config files for the primary and secondary pi.


## File Information

The `xorg.conf` tells the Xserver how to layout the video output from the pi onto the screen. 
This file is only needed on the primary pi.
The `xorg.conf` file should be placed in `/etc/X11/`.

The `config.txt` file is the equivalent of a BIOS on the pi. It contains system configuration parameters. 
This file is needed on the primary and secondary pi.
The `config.txt` file should be placed in `/boot/`.
