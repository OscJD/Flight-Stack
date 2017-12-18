#!/usr/bin/env python
""" Flight Stack """
""" wp-mission.py -> Script that makes a pixhawk perform a mission of different way-points. DroneKit 2.0 related. """

__author__ = "Aldo Vargas"
__copyright__ = "Copyright 2016 Altax.net"

__license__ = "GPL"
__version__ = "2.0"
__maintainer__ = "Aldo Vargas"
__email__ = "aldo@altax.net"
__status__ = "Development"

import time
from dronekit import connect, VehicleMode, LocationGlobalRelative, LocationGlobal, Command
from pymavlink import mavutil
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

print " -> Clearing previous mission commands..."
cmds = vehicle.commands
cmds.clear() 
print "Done."
time.sleep(2)

print " -> Uploading new mission..."
wp1 = LocationGlobalRelative(55.870113,-4.286798, 30)
wp2 = LocationGlobalRelative(55.869722,-4.288514, 30)
wp3 = LocationGlobalRelative(55.870360,-4.291787, 30)
wp4 = LocationGlobalRelative(55.870469,-4.289915, 30)
wp5 = LocationGlobalRelative(55.870186,-4.287978, 30)
wpX = LocationGlobalRelative(55.870186,-4.287978, 30)

cmds.add(Command( 0, 0, 0, mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT, mavutil.mavlink.MAV_CMD_NAV_WAYPOINT, 0, 0, 0, 0, 0, 0, wp1.lat, wp1.lon, wp1.alt))
cmds.add(Command( 0, 0, 0, mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT, mavutil.mavlink.MAV_CMD_NAV_WAYPOINT, 0, 0, 0, 0, 0, 0, wp2.lat, wp2.lon, wp2.alt))
cmds.add(Command( 0, 0, 0, mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT, mavutil.mavlink.MAV_CMD_NAV_WAYPOINT, 0, 0, 0, 0, 0, 0, wp3.lat, wp3.lon, wp3.alt))
cmds.add(Command( 0, 0, 0, mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT, mavutil.mavlink.MAV_CMD_NAV_WAYPOINT, 0, 0, 0, 0, 0, 0, wp4.lat, wp4.lon, wp4.alt))
cmds.add(Command( 0, 0, 0, mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT, mavutil.mavlink.MAV_CMD_NAV_WAYPOINT, 0, 0, 0, 0, 0, 0, wp5.lat, wp5.lon, wp5.alt))
#add dummy waypoint "5" at point 4 (lets us know when have reached destination)
cmds.add(Command( 0, 0, 0, mavutil.mavlink.MAV_FRAME_GLOBAL_RELATIVE_ALT, mavutil.mavlink.MAV_CMD_NAV_WAYPOINT, 0, 0, 0, 0, 0, 0, wpX.lat, wpX.lon, wpX.alt))    
cmds.upload()
print "Done uploading."
time.sleep(2)

print "\n\nAttempting to start take off!!\n\n"

arm_and_takeoff(vehicle, 10)

print " -> Starting mission!!"
time.sleep(1)
# Reset mission set to first (0) waypoint
vehicle.commands.next=0
vehicle.mode = VehicleMode("AUTO")

while True:
    nextwaypoint=vehicle.commands.next
    print 'Distance to waypoint (%s): %s' % (nextwaypoint, distance_to_current_waypoint(vehicle))

    if nextwaypoint==5: #Dummy waypoint - as soon as we reach waypoint 4 this is true and we exit.
        print "Exit 'standard' mission when start heading to final waypoint (6)"
        break;
    time.sleep(1)

vehicle.mode = VehicleMode("RTL")

while vehicle.armed:
    print "Current altitude: ", vehicle.location.global_relative_frame.alt
    time.sleep(0.5)

print "\n\nMission complete! :)\n\n"
vehicle.close()