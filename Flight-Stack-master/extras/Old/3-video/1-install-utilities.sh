#!/bin/bash

# 
Installation () {
	PACK[0]="gstreamer1.0"
	echo ""
	echo "-> Beginning installation!"
	echo ""
	sleep 2
	echo "-> Updating apt-get... (this tool may ask for root password)"
	echo ""
	sudo apt-get update
	sudo apt-get upgrade -y
	echo ""
	echo "-> Installing new packages..."
	echo ""
	sudo apt-get install ${PACK[*]} -y
	sudo apt-get update
	sudo apt-get upgrade -y
	echo ""
	echo "The next script being executed after the installation should be: 2-create-network.sh"
	echo "There might be warnings of the OS when booting up."
	echo "If you saw errors, please report them to: aldo@altax.net"
	echo ""
}

clear
echo ""
echo "----------- AlTaX consulting ---------"
echo "------------ Install script ----------"
echo ""
echo "Hi!"
echo ""
echo "This tool is designed to work on a companion computer,"
echo "running Linux, with access to internet."
echo "Does your CC meets those two requirements?:"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) Installation; break;;
        No ) echo ""; echo "Bye!"; echo ""; exit;;
    esac
done