#!/usr/bin/env python
""" Flight Stack """
""" 3-take-off.py -> Script that makes a pixhawk take off in a secure way. DroneKit 2.0 related. """

__author__ = "Aldo Vargas"
__copyright__ = "Copyright 2016 Altax.net"

__license__ = "GPL"
__version__ = "2.0"
__maintainer__ = "Aldo Vargas"
__email__ = "aldo@altax.net"
__status__ = "Development"

import time
from dronekit import connect, VehicleMode

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

def arm_and_takeoff(vehicle, aTargetAltitude):
	"""
	Arms vehicle and fly to aTargetAltitude.
	"""
	print "Basic pre-arm checks"
	# Don't let the user try to fly autopilot is booting
	if vehicle.mode.name == "INITIALISING":
		print "Waiting for vehicle to initialise"
		time.sleep(1)
	while vehicle.gps_0.fix_type < 2:
		print "Waiting for GPS...:", vehicle.gps_0.fix_type
		time.sleep(1)
		
	print "Arming motors"
	vehicle.mode    = VehicleMode("GUIDED")
	vehicle.armed   = True

	while not vehicle.armed:
		print "Waiting for arming..."
		time.sleep(1)

	print "Taking off!"
	vehicle.simple_takeoff(aTargetAltitude) # Take off to target altitude

	while vehicle.mode.name=="GUIDED":
		print " -> Altitude: ", vehicle.location.global_relative_frame.alt
		if vehicle.location.global_relative_frame.alt>=aTargetAltitude*0.95: #Just below target, in case of undershoot.
			print "Reached target altitude"
			break;
		time.sleep(1)


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