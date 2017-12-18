#!/usr/bin/env python
""" Flight Stack """
""" wp-simple.py -> Script that makes a pixhawk track a series of way-points in a very simple way. DroneKit 2.0 related. """

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

point1 = LocationGlobalRelative(55.870586,-4.287632, 25)
go_to(vehicle, point1)

point2 = LocationGlobalRelative(55.870548,-4.287313, 25)
go_to(vehicle, point2)

point3 = LocationGlobalRelative(55.870519,-4.287637, 25)
go_to(vehicle, point3)

point4 = LocationGlobalRelative(55.870576,-4.288043, 20)
go_to(vehicle, point4)

vehicle.mode = VehicleMode("RTL")

while vehicle.armed:
    print "Current altitude: ", vehicle.location.global_relative_frame.alt
    time.sleep(0.5)

print "\n\nMission complete! :)\n\n"
vehicle.close()