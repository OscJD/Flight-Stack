#!/bin/bash

# Switch interfaces files
Switch () {
	echo ""
	echo " -> Switching interfaces file to router mode..."
	cp /etc/network/interfaces-router /etc/network/interfaces
	echo " -> Done."
}

clear
echo ""
echo "----------- AlTaX consulting ---------"
echo "------------ Install script ----------"
echo ""
echo "Hi!"
echo ""
sudo echo "This script will switch interfaces files."
sleep 2
Switch