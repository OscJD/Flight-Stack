#!/bin/bash

# 
Installation () {
	echo ""
	echo "-> Beginning installation!"
	echo ""
	sleep 2
	echo "-> Updating apt-get... (this tool may ask for root password)"
	echo ""
	sudo apt-get update
	sudo apt-get upgrade -y
	echo ""
	echo "-> Creating file for telemetry daemon..."
	echo ""
	sudo touch /etc/init.d/mavlink
	sudo chmod 755 /etc/init.d/mavlink
	sudo echo '#!/bin/bash' >> /etc/init.d/mavlink
	sudo echo '/home/pi/Flight-Stack/3-video/startup/mavlink-start.sh' >> /etc/init.d/mavlink
	sudo update-rc.d mavlink defaults
	sleep 2
	echo "Done."

	echo ""
	echo "-> Creating file for video daemon..."
	echo ""
	sudo touch /etc/init.d/video
	sudo chmod 755 /etc/init.d/video
	sudo echo '#!/bin/bash' >> /etc/init.d/video
	sudo echo '/home/pi/Flight-Stack/3-video/startup/video-start.sh' >> /etc/init.d/video
	sudo update-rc.d video defaults
	sleep 2
	echo "Done."
}

clear
echo ""
echo "----------- AlTaX consulting ---------"
echo "------------ Install script ----------"
echo ""
echo "Hi!"
echo ""
echo "This tool will create startup scripts for: "
echo "- Video transmission"
echo "- Mavlink telemetry"
echo "Proceed? "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) Installation; break;;
        No ) echo ""; echo "Bye!"; echo ""; exit;;
    esac
done