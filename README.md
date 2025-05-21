# Raspberry-Pi-AirPlay-to-Headphone
Bash scripts to install Raspberry Pi AirPlay-to-Headphone Jack

To install put all seven script files on your RP. Make them all executable (`chmod +x 0*_*.sh`) then execute the script with: `./00_full_setup.sh`


This repository contains a complete set of Bash scripts to configure a Raspberry Pi as an AirPlay 2 audio receiver using Shairport Sync and nqptp. The scripts automate the installation of all required dependencies, build Shairport Sync with AirPlay 2 support, set up audio routing to the analog headphone jack, configure systemd services for automatic startup, and ensure output volume is correctly set. A master installer script (00_full_setup.sh) runs all steps in sequence, with logging and status output, making it easy to deploy a working AirPlay-to-headphone bridge on a fresh Raspberry Pi OS installation.

This has been tested on Raspberry Pi 3 Model B with Raspberry Pi OS (64-bit) Released: 2025-05-13

There is one point where you have to enter a selection of the sink - typically you have only one, select that one (by entering 0 - zero). If there is more than one then you likely have more than one hardware audio output - you will have to select the one you want to use.

When the script(s) are done - the system should be running. It will startup when the RP is restarted.

The AirPlay NAME that will be displayed on an AirpPlay client is the HOSTNAME of the RP when these install scripts are run.

These scripts are provided with **no license** and **USE AT YOUR OWN RISK**
These scripts should not do any damage - but I am not responsible for what you do with and the results of any use of these scripts.
