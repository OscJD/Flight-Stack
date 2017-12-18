#!/bin/bash

pass="1234567890"

# Backup original and create new interfaces file
Interfaces () {
	echo ""
	echo " -> Creating a neutral interfaces file for wlan0 and wlan1"
	#sudo echo $'source-directory /etc/network/interfaces.d\n\nauto lo\niface lo inet loopback\n\niface eth0 inet manual\n\nauto wlan0\niface wlan0 inet static\n\taddress 85.85.85.1\n\tnetmask 255.255.255.0' > /etc/network/interfaces-router
interfacesdata="# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

iface eth0 inet manual

allow-hotplug wlan0
iface wlan0 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

allow-hotplug wlan1
iface wlan1 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

"
	echo "$interfacesdata" > /etc/network/interfaces-router
	echo " -> Done."
}

clear
echo ""
echo "----------- AlTaX consulting ---------"
echo "---- Wireless Installation script ----"
echo ""
echo "Hi!"
echo ""
echo "This script will return the wireless configuration to the original one."
echo "Are you sure you want to do it?: "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) Interfaces; break;;
        No ) echo ""; echo "Bye!"; echo ""; exit;;
    esac
done