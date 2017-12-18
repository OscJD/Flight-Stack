![Altax](https://altax.net/images/altax.png "Altax")

# Simulator

In this folder, the tools necessary to start working with the simulator and some example scripts will be showed.

## 1. Installation

Only MacOS X and Ubuntu LTS 14.04 are supported (by an installation script). For the rest of the O.S., please contact Aldux at aldo@altax.net

1.- Clone this repository (It will as for your credentials, login and password.)
```
git clone https://github.com/alduxvm/Flight-Stack
```

2.- Navigate to the simulator folder:
```
cd Flight-Stack/simulator
```

Requirements before executing the installation script:

* Having homebrew on the machine. (http://brew.sh/)

3.- Execute the installation script: 
```
./1-install-simulator.sh
```

* If you encounter errors other than `Error: package already installed`, `Cannot uninstall requirement package, not installed` and other general yellow warnings, please report them to aldo@altax.net


## 2. Basic usage

After installation is complete, we can proceed to do some general testing to see if the simulator works and the basic usage of it.

Requirements for this section to work:

* Have installed the application called "APM Planner 2.0"

1.- Execute the basic usage script:
```
./2-basic-usage.sh
```

* That script will open two new windows, one for the APM Planner application and the other one where the simulator is going to run.

2.- On the main window (where the shell script was executed...) you will see its now inside another text-based command-line terminal. This one is basically a text ground station for the simulator. Give a couple of enters so that you "clean" the rest of the messages, as showed on the next image:

![Simulator-1](https://altax.net/images/fs/sim/1.jpg "Simulator-1")

3.- As test, we are going to make the vehicle take off and holding a position at 100 meters. To do that on type the next commands (one "enter" per line):

1. `mode guided`
2. `arm thorttle`
3. `takeoff 100`

![Simulator-2](https://altax.net/images/fs/sim/2.jpg "Simulator-2")

4.- To land the vehicle, simply type:
```
mode land
```

* If you're done using the simulator, you can close "APM Planner" and the extra simulator terminal window.

## 3. Python usage

The next example is the first usage of the python language along side the simulator, this repository contains two examples of usage:

* `./3-show-data.sh` -> Simply ask the simulated flight controller for data and show it
* `./4-take-off.sh` -> Connect to the simulated flight controller and make it arm and take off at 10 meters, wait for 5 seconds and then land.

As before, this bash scripts will open all of the necessary terminal windows, and in the main window is where the python script is executed, the windows can be seen as different parts of the entire system, those parts are:

* Vehicle -> The vehicle is simulated using a terminal window that is running SITL
* Flight-Stack -> The connection between the pixhawk and the rpi is simulated in another window using the mavproxy command
* Main window -> This window is the user one, either on simulation or in reality, where the scripts are going to be executed, this one will run the python scripts

### Show data script

To execute and test this script simply do this on a terminal window:

```
./3-show-data.sh
```

This script will open two windows, one for the simulator, one for mavproxy and in the main window (where you started the command) you will see the python output, which is a stream of data at 20hz, displaying the next information of the simulated flight controller:
* Attitude
* Velocity
* RC channels
* Altitude
* Altitude (global relative frame)
* Vehicle name

![Simulator-show-data](https://altax.net/images/fs/sim/sim-show.png "Simulator-show-data")

* Remember to close the extra terminal windows when completing using this script, so that it does not interfere with further scripts.

### Take off script

To execute and test this script simply do this on a terminal window:

```
./4-take-off.sh
```

This script will open two windows, one for the simulator, one for mavproxy and in the main window (where you started the command) you will see the python output, which will describe the process for arming the vehicle and taking off to 10 meters, hover for 5 seconds and proceed to land.

![Simulator-take-off](https://altax.net/images/fs/sim/sim-takeoff.png "Simulator-take-off")

* Remember to close the extra terminal windows when completing using this script, so that it does not interfere with further scripts.

#### Modification to APM Planner 

In order to make this script more interactive and realistic, we need to modify the app "APM Planner" (Only on MacOSX), and add a UDP link using the port `14549` as showed on the next image:

![Planner-mod](https://altax.net/images/fs/sim/planner-mod.png "Planner-mod")

If that modification is done, then you can proceed and execute the code again and the simulator will open and you will see the GUI moving and the vehicle taking off and land. The mission will last approximately 35 seconds.

![Simulator-take-off-2](https://altax.net/images/fs/sim/sim-takeoff2.png "Simulator-take-off-2")

