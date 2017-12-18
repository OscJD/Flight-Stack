![Altax](https://altax.net/images/altax.png "Altax")

# Companion Computer 

In this folder, the tools necessary to start working with the companion computer and some example scripts will be showed.

## 1. Considerations

The Companion computer must be on-board the vehicle and with the next add-ons:

* The RPI must be powered by a 5v BEC; not powered by the Pixhawk common rail, as this could make the Pixhawk reboot mid-flight and cause accidents
* Serial connection between the RPI and the Pixhawk, connect the RPI pins RX/TX/GND to the Telem2 port of the Pixhawk
* At the beginning the RPI must have internet access via wifi or ethernet, in order to install the utilities to make them talk together
* If the vehicle is big to be connected to a monitor, or when testing the script number 3, then making SSH to the RPI is required

Example of a Pixhawk connected to a RPI mounted on a quadrotor vehicle:
![Test-Quad](https://altax.net/images/fs/cc/test-quad.jpg "Test-Quad")

## 2. Installation

At this moment, the installation script is tested only for Raspberry Pi 2/3 with Raspbian. For the rest of the O.S., please contact Aldux at aldo@altax.net

1.- Clone this repository or sync it to get the latests updates on the companion computer (Internet is needed and it will as for your credentials, login and password.)
```
git clone https://github.com/alduxvm/Flight-Stack
```

2.- Navigate to the simulator folder:
```
cd Flight-Stack/companion-computer
```

3.- Execute the installation script: 
```
./1-install-utilities.sh
```

* If you encounter errors other than `Error: package already installed`, `Cannot uninstall requirement package, not installed` and other general yellow warnings, please report them to aldo@altax.net


## 3. Basic usage

After installation is complete, we can proceed to do some general testing to check the communication with the vehicle is successful.

1.- Test connection with vehicle using MAVProxy, execute this line on the companion computer:
```
mavproxy.py --master=/dev/ttyAMA0 --baudrate 115200 --aircraft TestQuad
```
* The parameter `--master=/dev/ttyAMA0` is the selection of the physical port of the RPI
* The parameter `--baudrate 115200` configures the communication serial baud rate
* The parameter `--aircraft TestQuad` can be changed to the name of the vehicle, there will be a folder created with the name we chose here for log saving

If you see a response on the command line similar to the next image, it means the RPI has successfully connected to the Pixhawk:


2.- If the connection test with `mavproxy.py worked, then we can proceed to test the next script to check the connection with the Dronekit python framework:
```
python 2-show-data.py --connect /dev/ttyAMA0
```
The output of this script would be refreshed every 0.05 seconds (20hz), and it will display something like on the command terminal of the RPI:

![Show-Data](https://altax.net/images/fs/cc/showdata.png "Show-Data")

3.- If the previous script worked perfectly, the next step is going with the vehicle outside and test the next script that will take-off the vehicle autonomously at 10 meters (while holding the position), wait for 5 seconds and then proceed to land. Special considerations need to be taken care off before attempting this script:

* The vehicle must fly perfectly 
* The vehicle must be capable of functioning in the next modes: Loiter, Auto Mission (GPS usage)
* When executing this script be sure that the battery is charged and will have enough power to fly for 1-2 minutes
* Take the vehicle outside, with at least a 10 meter radius of clear space
* Check the GPS is working properly and that the vehicle is flyable
* Arm and fly in loiter mode the vehicle before attempting the script, land and proceed with the instructions
* SSH to the RPI and execute the next line:
```
python 3-take-off.py --connect /dev/ttyAMA0
```

The script will attempt connection to the vehicle, and then proceed to arm the vehicle and take-off to 10 meters, then wait for 5 seconds, and then land. 

