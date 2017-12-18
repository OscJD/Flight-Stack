#!/usr/bin/env python
""" Flight Stack """
""" take-off.py -> Script that makes a pixhawk take off in a secure way. DroneKit 2.0 related. """

__author__ = "Aldo Vargas"
__copyright__ = "Copyright 2016 Altax.net"

__license__ = "GPL"
__version__ = "2.0"
__maintainer__ = "Aldo Vargas"
__email__ = "aldo@altax.net"
__status__ = "Development"

import time
from dronekit import connect, VehicleMode
from droneFunctions import *

#Set up option parsing to get connection string
import argparse  
parser = argparse.ArgumentParser(description='Print out vehicle state information. Connects to SITL on local PC by default.')
parser.add_argument('--connect', 
                   help="vehicle connection target string. If not specified, SITL automatically started and used.")
args = parser.parse_args()
connection_string = args.connect
sitl = None

#Start SITL if no connection string specified
if not connection_string:
    import dronekit_sitl
    sitl = dronekit_sitl.start_default()
    connection_string = sitl.connection_string()

# Connect to the Vehicle. 
#   Set `wait_ready=True` to ensure default attributes are populated before `connect()` returns.
print "\nConnecting to vehicle on: %s" % connection_string
vehicle = connect(connection_string, baud=57600, wait_ready=True)

""" Mission starts here """
print "\n\nMission Starting!!\n\n"
time.sleep(2)
print "\n\nAttempting to start take off!!\n\n"
arm_and_takeoff(vehicle, 10)
print "Wait 5 seconds before going landing"
print "Current altitude: ", vehicle.location.global_relative_frame.alt
time.sleep(5)
print "\n\nLanding!\n\n"
#vehicle.mode = VehicleMode("RTL")
vehicle.mode = VehicleMode("LAND")

while vehicle.armed:
    print "Current altitude: ", vehicle.location.global_relative_frame.alt
    time.sleep(0.5)

print "\n\nMission complete! :)\n\n"
vehicle.close()