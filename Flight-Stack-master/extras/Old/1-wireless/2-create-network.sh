#!/bin/bash

# General Configuration
interfaceAP="wlan0"
interfaceC="wlan1"
channel=1
pass="1234567890"

# Backup original and create new interfaces file
Interfaces () {
	echo ""
	echo " -> Backing up original interfaces file to 'interfaces-original'..."
	sudo cp /etc/network/interfaces /etc/network/interfaces-original
	echo " -> Done."
	echo ""
	echo " -> Creating new interfaces file for $interfaceAP and $interfaceC"
	#sudo echo $'source-directory /etc/network/interfaces.d\n\nauto lo\niface lo inet loopback\n\niface eth0 inet manual\n\nauto wlan0\niface wlan0 inet static\n\taddress 85.85.85.1\n\tnetmask 255.255.255.0' > /etc/network/interfaces-router
interfacesdata="# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

iface eth0 inet manual

allow-hotplug $interfaceC
iface $interfaceC inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

auto $interfaceAP
iface $interfaceAP inet static
	address 85.85.85.1
	netmask 255.255.255.0

"
	echo "$interfacesdata" > /etc/network/interfaces-router
	echo " -> Done."
}

# Switch interfaces files
Switch () {
	echo ""
	echo " -> Switching interfaces file to router mode..."
	sudo cp /etc/network/interfaces-router /etc/network/interfaces
	echo " -> Done."
}

# Create hostapd file
Hostapd () {
	echo ""
	echo " -> Creating hostapd.conf file with next data:"
	echo "       Wireless Network Name: AlTaX-Veh-$HOSTNAME"
	echo "       Password: $pass"
	echo "       Channel: $channel"
	echo "       Interface and driver: $interface $driver"
	#sudo echo -e "interface=$interface\ndriver=$driver\n\nctrl_interface=/var/run/hostapd\nctrl_interface_group=0\n\nssid=AltaX-Veh-$HOSTNAME\nhw_mode=g\nchannel=$channel\nieee80211n=1\n\nwpa=2\nwpa_passphrase=$pass\n\nwpa_key_mgmt=WPA-PSK\nwpa_pairwise=CCMP\nrsn_pairwise=CCMP\nbeacon_int=100\nauth_algs=3\nwmm_enabled=1" > /etc/hostapd/hostapd.conf
hostapddata="interface=$interfaceAP
driver=nl80211

ctrl_interface=/var/run/hostapd
ctrl_interface_group=0

ssid=AltaX-Veh-$HOSTNAME
hw_mode=g
channel=$channel
ieee80211n=1

#macaddr_acl=0
#auth_algs=3
#ignore_broadcast_ssid=0

wpa=2
wpa_passphrase=$pass

wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP

beacon_int=100
auth_algs=3
wmm_enabled=1

"
	echo "$hostapddata" > /etc/hostapd/hostapd.conf
	echo " -> Done."
}

# Link hostapd file
LinkHostapd () {
echo ""
echo " -> Linking hostapd.conf to default"
sudo cat >/etc/default/hostapd <<EOL
# Defaults for hostapd initscript
#
# See /usr/share/doc/hostapd/README.Debian for information about alternative
# methods of managing hostapd.
#
# Uncomment and set DAEMON_CONF to the absolute path of a hostapd configuration
# file and hostapd will be started during system boot. An example configuration
# file can be found at /usr/share/doc/hostapd/examples/hostapd.conf.gz
#
DAEMON_CONF="/etc/hostapd/hostapd.conf"

# Additional daemon options to be appended to hostapd command:-
# 	-d   show more debug messages (-dd for even more)
# 	-K   include key data in debug messages
# 	-t   include timestamps in some debug messages
#
# Note that -B (daemon mode) and -P (pidfile) options are automatically
# configured by the init.d script and must not be added to DAEMON_OPTS.
#
#DAEMON_OPTS=""

EOL
echo " -> Done."
}

# Create isc-dhcp-server file
ISC-DHCP () {
echo ""
echo " -> Creating isc-dhcp-server file..."
iscdhcp="# Defaults for isc-dhcp-server initscript
# sourced by /etc/init.d/isc-dhcp-server
# installed at /etc/default/isc-dhcp-server by the maintainer scripts

#
# This is a POSIX shell fragment
#

# Path to dhcpds config file (default: /etc/dhcp/dhcpd.conf).
DHCPD_CONF=/etc/dhcp/dhcpd.conf

# Path to dhcpds PID file (default: /var/run/dhcpd.pid).
#DHCPD_PID=/var/run/dhcpd.pid

# Additional options to start dhcpd with.
#	Dont use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#	Separate multiple interfaces with spaces, e.g. \"eth0 eth1\".
INTERFACES=\"$interfaceAP\"

"
	echo "$iscdhcp" > /etc/default/isc-dhcp-server
	echo " -> Done." 
}

# Create dhcp.conf file
DHCP () {
echo ""
echo " -> Creating dhcpd.conf file..."
sudo cat >/etc/dhcp/dhcpd.conf <<EOL

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# A slightly different configuration for an internal subnet.
subnet 85.85.85.0 netmask 255.255.255.224 {
  range 85.85.85.1 85.85.85.10;
  option domain-name-servers ns1.internal.example.org;
  option domain-name "internal.example.org";
  option routers 85.85.85.1;
  option broadcast-address 85.85.85.1;
  default-lease-time 600;
  max-lease-time 7200;
}

EOL
echo " -> Done." 
}

# Main installation function
Installation () {
	echo ""
	echo "Choose which interface will create the Access Point, there is two options:"
	PS3='What interface corresponds to the external wireless dongle?: '
	options=("wlan0" "wlan1")
	select opt in "${options[@]}"
	do
	    case $opt in
	        "wlan0")
				interfaceAP="wlan0"
				interfaceC="wlan1"
				break
	            ;;
	        "wlan1")
	            interfaceAP="wlan1"
	            interfaceC="wlan0"
	            break
	            ;;
	        *) echo invalid option;;
	    esac
	done
	echo ""
	echo "The AccessPoint will be on $interfaceAP and the client will be $interfaceC"
	sleep 2
	echo ""
	echo "Interfaces part..."
	Interfaces
	sleep 2
	echo ""
	echo "Switch interfaces files..."
	Switch
	sleep 2
	echo ""
	echo "Hostapd part..."
	Hostapd
	sleep 2
	echo ""
	echo "Lint Hostapd..."
	LinkHostapd
	sleep 2
	echo ""
	echo "ISC-DHCP-SERVER part..."
	ISC-DHCP
	sleep 2
	echo ""
	echo "DHCP part..."
	DHCP
	sleep 2
	echo "Installation done."
	read -p "Do you want to reboot now (y/n)?" choice
	case "$choice" in 
	  y|Y ) sudo reboot;;
	  n|N ) echo "Bye!"; echo ""; exit;;
	  * ) echo "invalid option";;
	esac
}

clear
echo ""
echo "----------- AlTaX consulting ---------"
echo "---- Wireless Installation script ----"
echo ""
echo "Hi!"
echo ""
echo "This tool is designed to work on Raspbian, with access to internet."
echo "Does your Raspberry Pi meets those two requirements?: "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) Installation; break;;
        No ) echo ""; echo "Bye!"; echo ""; exit;;
    esac
done