#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
echo 'Pulling wifi and bluetooth firmware sources from arch-mact2 repo'
wget https://mirror.funami.tech/arch-mact2/firmware/bluetooth.tar.gz
wget https://mirror.funami.tech/arch-mact2/firmware/wifi.tar.gz

echo 'Cloning asahi-installer fork used to package firmware'
git clone https://github.com/NoaHimesaka1873/asahi-installer

echo 'Extracting sources'
cd asahi-installer
mkdir wifi
mkdir bluetooth
tar xf ../wifi.tar.gz --directory wifi/
tar xf ../bluetooth.tar.gz --directory bluetooth/

echo 'Running asahi-installer to package firmware'
mkdir ../firmware-wifi
mkdir ../firmware-bluetooth
python3 -m asahi_firmware.wifi wifi ../firmware-wifi
python3 -m asahi_firmware.bluetooth bluetooth ../firmware-bluetooth

echo 'Installing firmware where Fedora desires'
tar xf ../firmware-wifi/firmware.tar --directory /lib/firmware
tar xf ../firmware-bluetooth/firmware.tar --directory /lib/firmware