#!/bin/bash

# Find out which OS is running:
askOS () {
	plataform="unknown"
	unamestr=`uname`
	case "$unamestr" in
		"Linux") plataform='installLinux' 
		;;
		"Darwin") plataform='installMac' 
		;;
		*)
		echo "" 
		echo "Sorry, platform not supported... :("
		echo "" 
		exit
		;;
	esac
}
askOS;

# Installation for MacOSX
installMac () {
	echo ""
	echo "-> Beginning MacOSX installation!"
	echo ""
	sleep 2
	echo "-> Updating homebrew..."
	echo ""
	brew update
	brew install python
	echo ""
	echo "-> Updating pip..."
	echo ""
	yes | pip install --upgrade pip
	echo ""
	echo "-> Removing old installations... (this tool will ask for admin password)"
	echo ""
	sleep 2
	sudo pip uninstall dronekit -y
	sudo pip uninstall dronekit-sitl -y
	sudo pip uninstall MAVProxy -y
	sudo pip uninstall pymavlink -y
	echo ""
	echo "-> Installing the new stuff!"
	echo "" 
	# probably change to install from source
	yes | sudo pip install dronekit
	yes | sudo pip install dronekit-sitl
	brew tap homebrew/science
	brew install wxmac wxpython opencv
	brew update
	sudo pip uninstall python-dateutil
	pip install numpy pyparsing
	sudo pip install numpy --upgrade
	sudo pip install pyparsing --upgrade
	yes | sudo pip install MAVProxy
	echo ""
	echo "If you saw errors, please report them to: aldo@altax.net"
	echo ""
}

installLinux () {
	PACK[0]="python-dev"
	PACK[1]="screen"
	PACK[2]="python-wxgtk2.8"
	PACK[3]="python-matplotlib"
	PACK[4]="python-opencv"
	PACK[5]="python-pip"
	PACK[6]="python-numpy"
	PACK[7]="python-serial"
	echo ""
	echo "-> Beginning Linux installation!"
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
	echo ""
	echo "-> Updating pip..."
	echo ""
	yes | pip install --upgrade pip
	echo ""
	echo "-> Removing old installations..."
	echo ""
	sleep 2
	sudo pip uninstall dronekit -y
	sudo pip uninstall MAVProxy -y
	sudo pip uninstall pymavlink -y
	echo ""
	echo "-> Installing the new stuff!"
	echo "" 
	yes | sudo pip install MAVProxy
	yes | sudo pip install dronekit
	yes | sudo pip install dronekit-sitl
	#sudo pip uninstall python-dateutil
	#pip install numpy pyparsing
	#sudo pip install numpy --upgrade
	#sudo pip install pyparsing --upgrade
	echo ""
	echo ""
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
echo "I found $unamestr as system..."
echo "This tool is designed to work on MacOSX/Linux systems with internet."
echo "For Mac I need homebrew as well..."
echo "Does your computer meets these requirements?:"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) $plataform; break;;
        No ) echo ""; echo "Bye!"; echo ""; exit;;
    esac
done