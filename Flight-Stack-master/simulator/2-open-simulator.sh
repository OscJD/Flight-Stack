#!/bin/bash

# Find out which OS is running:
askOS () {
	plataform="unknown"
	unamestr=`uname`
	case "$unamestr" in
		"Linux") plataform='Linux'
		;;
		"Darwin") plataform='Mac'
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

# Open APM Planner
OpenPlanner () {
	open /Applications/QGroundControl.app/
}

# Open simulator in anther terminal
OpenSITLMac () {
	osascript -e 'tell application "Terminal" to do script "dronekit-sitl copter --home=55.870595,-4.287639,0,0"'
}

# Open simulator in anther terminal
OpenSITLLinux () {
	gnome-terminal -e "bash -c \"cd; dronekit-sitl ./ardupilot/ArduCopter/ArduCopter.elf --home=55.870595,-4.287639,0,0; exec bash\""
}

# Main stuff:
clear
echo ""
echo "----------- AlTaX consulting ---------"
echo "------- Open simulator script  -------"
echo ""
echo "This tool open applications and other terminal window automatically."
echo "(You can close them once they are not in use)"
echo ""
sleep 2
case $plataform in
	"Mac")
		echo "Starting SITL in a new terminal window..."
		echo ""
		OpenSITLMac
		sleep 3
		echo ""
		echo "Starting APM Planner to be able to visualize the vehicle..."
		echo ""
		OpenPlanner
		sleep 4
		echo ""
		echo "Starting MAVProxy..."
		echo ""
		sleep 5
		mavproxy.py --master=tcp:127.0.0.1:5760 --out=udpout:127.0.0.1:14550 --out=udpout:127.0.0.1:14549
		;;
	"Linux")
		echo "Starting SITL in a new terminal window..."
		echo ""
		OpenSITLLinux
		sleep 2
		echo ""
		echo "Starting MAVProxy..."
		echo ""
		sleep 5
		mavproxy.py --master=tcp:127.0.0.1:5760 --out=udpout:127.0.0.1:14550 --out=udpout:127.0.0.1:14549
		;;
esac
