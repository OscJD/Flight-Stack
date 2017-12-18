#!/usr/bin/env python
""" Flight Stack """
""" show-data.py -> Script that shows data from a vehicle. DroneKit 2.0 related. """

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

while True:
	print "%s" % vehicle.attitude #SR2_EXTRA1
	print "%s" % vehicle.velocity #SR2_POSITION
	print "%s" % vehicle.channels #SR2_RC_CHAN
	print "Altitude (global frame): %s" % vehicle.location.global_frame.alt
	print "Altitude (global relative frame): %s" % vehicle.location.global_relative_frame.alt
	print "%s" % vehicle.mode.name
	time.sleep(0.05)

vehicle.close()