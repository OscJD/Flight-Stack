![Altax](https://altax.net/images/altax.png "Altax")

# Video transmission 

In this folder, the tools necessary to start working with the companion computer and some example scripts will be showed.

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

2.- Navigate to the simulator folder:
```
cd Flight-Stack/video
```

3.- Execute the installation script: 
```
./1-install-utilities.sh
```

* If you encounter errors other than `Error: package already installed`, `Cannot uninstall requirement package, not installed` and other general yellow warnings, please report them to aldo@altax.net

* Also, you need to have the dongle connected when doing the install, because the OS automatically will install the appropriate drivers for the dongle (If fully compatible)

## 3. Video transmission

1.- Start transmission:
```
./start-video-transmission.sh
```

## Manual commands

* Send stream command using a raspberry pi camera (just replace the 85.85.85.5 with the address of your receiver computer or ground station):

```
raspivid -n -vf -hf -w 640 -h 480 -t 0 -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=10 pt=96 ! udpsink host=85.85.85.5 port=5600
``` 

* Send stream command using a usb webcam connected to the raspberry pi (just replace the 85.85.85.5 with the address of your receiver computer or ground station):

```
gst-launch-1.0 v4l2src device=/dev/video0 ! h264parse ! rtph264pay config-interval=10 pt=96 ! udpsink host=85.85.85.5 port=5600`
```

* Receive stream command on a mac terminal:

```
gst-launch-1.0 -v udpsrc port=5600 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264' ! rtph264depay ! video/x-h264,width=640,height=480,framerate=30/1 ! h264parse ! avdec_h264 ! videoconvert ! autovideosink sync=false
```

Also if the application called qgroundcontrol is used, the stream will be seen if using the port 5600. 

## Recommendations

Change the next settings on raspi-config:

* hostname : Choose a hostname for the raspberry pi, to be identified easier, this name will be mixed with the wifi ssid
* boot faster network: Choose to do not wait for network configuration
