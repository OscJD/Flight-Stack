#!/bin/bash

# General Configuration
ip="85.85.85.5"
ip2="85.85.85.6"
port="5600"
bitrate="1000000"
res1="1280"
res2="720"
fps="30"

# Change to 1 if B101 needs startup procedure
b101="0"

b101startprocedure () {
	echo "0" > /sys/class/gpio/gpio4/value
	echo "1" > /sys/class/gpio/gpio4/value
}

# Main installation function
videoTransmission () {
	# Single: 
	#raspivid -n -w 1280 -h 720 -t 0 -vf -hf -b $bitrate -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=10 pt=96 ! udpsink host=$ip port=$port
	# Multiple:
	raspivid -n -w $res1 -h $res2 -t 0 -vf -hf -fps $fps -b $bitrate -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=10 pt=96 ! multiudpsink clients=$ip:$port,$ip2:$port
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
if [ "$b101" = "1" ]
then
	b101startprocedure
else
	echo "Normal B101"
fi 
sleep 10
videoTransmission