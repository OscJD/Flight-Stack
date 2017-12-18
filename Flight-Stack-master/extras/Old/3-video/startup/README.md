![Altax](https://altax.net/images/altax.png "Altax")

# Video transmission startup scripts

In this folder, the tools necessary to make video transmission and telemetry startup at the boot procedure of the rpi will be explained.

## 1. Requirements

### Companion computer 

The CC must be on-board the vehicle and with the next add-ons:

* The RPI must be powered by a 5v BEC; not powered by the Pixhawk common rail, as this could make the Pixhawk reboot mid-flight and cause accidents
* At the beginning the RPI must have internet access via wifi or ethernet, in order to install the utilities to make them talk together
* If the vehicle is big to be connected to a monitor, use SSH to execute all commands
* Raspicam connected to the CSI port of the RPI (test it working `raspivid -t 0`)

### Wireless

* The wireless access point should be up and running (executing scripts on the "wireless" folder of this repository)
* Most likely, the internal wireless of the RPI3 should be connected to a "internet" network, and the external dongle in AP mode

## 2. Installation

At this moment, the installation script is tested only for Raspberry Pi 2/3 with Raspbian. For the rest of the O.S., please contact Aldux at aldo@altax.net

1.- Clone this repository or sync it to get the latests updates on the companion computer (Internet is needed and it will as for your credentials, login and password.)
```
git clone https://github.com/alduxvm/Flight-Stack
```

2.- Navigate to the startup folder:
```
cd Flight-Stack/video/startup
```

3.- Execute the installation script: 
```
./1-create-autostart.sh
```

This shell script will create the necessary files for making the video and telemetry process work at boot. The video boot will be handled as a process using init.d, while the telemetry one will be handled as a common startup script on the bashrc, this is due to file permissions. This requires that the rpi is setup to boot on "Console autologin" when using `sudo raspi-config`.

* If you encounter errors other than `Error: package already installed`, `Cannot uninstall requirement package, not installed` and other general yellow warnings, please report them to aldo@altax.net

* Also, you need to have the dongle connected when doing the install, because the OS automatically will install the appropriate drivers for the dongle (If fully compatible)

## Editable Options:

# For video:

In the file `Flight-Stack/video/startup/video-start.sh` there is options that can be configured for multiple udp clients and quality of the video, this ones can be modified directly on the file.
* ip -> The client ip to which the video is going to be sent.
* port -> The video port, is setup to 5600 due to the fact that is the standard for the qgroundcontrol application.
* bitrate -> This parameter is for quality, right now is setup to 1000kbps, its ideal to keep it in between 1-2mbps
* res1 and res2 -> The size of the video being sent, right now setup to high definition

# For telemetry:

In the file `Flight-Stack/video/startup/mavlink-start.sh` there is options that can be configured for multiple udp clients and port configurations.

* ip -> The client ip to which the telemetry is going to be sent.
* port -> The telemetry udp port, is setup to 14550 due to the fact that is the default for the several ground stations applications.
