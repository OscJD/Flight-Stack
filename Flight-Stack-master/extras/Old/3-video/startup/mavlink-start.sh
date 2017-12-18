#!/bin/bash

# General Configuration
ip="85.85.85.4"
ip2="85.85.85.5"
ip3="85.85.85.8"
port="14550"

# Main installation function
mavTransmission () {
	mavproxy.py --master=/dev/ttyAMA0,57600 --streamrate=20 --out=$ip:$port --out=$ip2:$port --out=$ip3:$port
	if [ $? -eq 0 ]; then
    	echo ""
    	echo ""
	    echo "  Command failed! check the connection between the pixhawk and the RPI, "
	    echo "  and try the script again... "
	    echo ""
	    echo "  If it fails again, please report to: aldo@altax.net"
	    echo ""
	    echo ""
	else
	    echo "  Command succeed!"
	fi
}

clear
echo ""
echo "----------- AlTaX consulting ---------"
echo "-------------- Telemetry  ------------"
echo ""
echo "Hi!"
echo ""
echo "Starting Mavlink telemetry transmission..."
echo ""
echo ""
sleep 10
mavTransmission