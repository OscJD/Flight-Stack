#!/bin/bash

# General Configuration
ip="85.85.85.4"
port="9000"

# Main installation function
videoTransmission () {
	raspivid -n -w 640 -h 480 -t 0 -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=10 pt=96 ! udpsink host=$ip port=$port
	if [ $? -eq 0 ]; then
    	echo ""
    	echo ""
	    echo "  Command failed! check that the RPI camera is connected, "
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
echo "---------- Video Transmission --------"
echo ""
echo "Hi!"
echo ""
echo "Starting video transmission..."
echo ""
echo ""
videoTransmission