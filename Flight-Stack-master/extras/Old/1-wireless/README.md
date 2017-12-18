![Altax](https://altax.net/images/altax.png "Altax")

# Wireless configuration 

In this folder, the tools necessary to start working with the companion computer and some example scripts will be showed.

## 1. Requirements

### Companion computer 

The CC must be on-board the vehicle and with the next add-ons:

* The RPI must be powered by a 5v BEC; not powered by the Pixhawk common rail, as this could make the Pixhawk reboot mid-flight and cause accidents
* At the beginning the RPI must have internet access via wifi or ethernet, in order to install the utilities to make them talk together
* If the vehicle is big to be connected to a monitor, or when testing the script number 3, then making SSH to the RPI is required

### Wireless Dongles

* Capable of AP mode (To check this do: `iw list | less`)
* 2.4 ghz or 5 ghz

#### How to find out which interface is which?

This process is important so that we are sure the correct wireless hardware is creating the access point. In order to do this, there are several process to be done:

* Unplug all wireless dongles from the rpi3 usb ports
* Execute `ifconfig` and you will have only one interface "wlan0", pay attention to the mac address, write it down so that we can identify it easily later
* Connect the external wireless dongle and do `ifconfig` again, the names of the interfaces might have change, but the mac address will not. The access point therefore will be the interface that will have a different mac address than the internal we wrote down on paper. This interface will be asked on the create network script. 

## 2. Installation

At this moment, the installation script is tested only for Raspberry Pi 2/3 with Raspbian. For the rest of the O.S., please contact Aldux at aldo@altax.net

1.- Clone this repository or sync it to get the latests updates on the companion computer (Internet is needed and it will as for your credentials, login and password.)
```
git clone https://github.com/alduxvm/Flight-Stack
```

2.- Navigate to the simulator folder:
```
cd Flight-Stack/wireless
```

3.- Execute the installation script: 
```
./1-install-utilities.sh
```

* If you encounter errors other than `Error: package already installed`, `Cannot uninstall requirement package, not installed` and other general yellow warnings, please report them to aldo@altax.net

* Also, you need to have the dongle connected when doing the install, because the OS automatically will install the appropriate drivers for the dongle (If fully compatible)

4.- Execute the create network script:
```
sudo ./2-create-network.sh
```

* This script will create the necessary files and configuration needed to create a wireless network using the interface selected, which is the external wireless dongle that is connected to the rpi3.

* When this script finishes it will ask to reboot, if everything went ok, then after boot, the internal wireless of the rpi3 will remain connected to the previous network while the other dongle will be acting as an access point, this new network is the one that we will use for further missions.

## Recommendations

Change the next settings on raspi-config:

* hostname : Choose a hostname for the raspberry pi, to be identified easier, this name will be mixed with the wifi ssid
* boot faster network: Choose to do not wait for network configuration
