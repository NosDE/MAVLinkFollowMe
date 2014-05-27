//
//  MAVHelper.m
//  MAVLinkFollowMe
//
//  Created by marco on 21.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import "MAVHelper.h"

@implementation MAVHelper

- (NSString*)getAutopilotNameByAutopilotID:(NSInteger)autopilotID
{
	switch (autopilotID) {
		case MAV_AUTOPILOT_GENERIC:
			return @"Generic";
			break;
		case MAV_AUTOPILOT_PIXHAWK:
			return @"Pixhawk";
			break;
		case MAV_AUTOPILOT_SLUGS:
			return @"Slugs";
			break;
		case MAV_AUTOPILOT_ARDUPILOTMEGA:
			return @"Ardupilot-Mega";
			break;
		case MAV_AUTOPILOT_OPENPILOT:
			return @"Openpilot";
			break;
		case MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY:
			return @"Gen. WP only";
			break;
		case MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY:
			return @"Gen. WP a. simple nav.";
			break;
		case MAV_AUTOPILOT_GENERIC_MISSION_FULL:
			return @"Gen. mission full";
			break;
		case MAV_AUTOPILOT_INVALID:
			return @"Invalid";
			break;
		case MAV_AUTOPILOT_PPZ:
			return @"PPZ";
			break;
		case MAV_AUTOPILOT_UDB:
			return @"UDB";
			break;
		case MAV_AUTOPILOT_FP:
			return @"FP";
			break;
		case MAV_AUTOPILOT_PX4:
			return @"PX4";
			break;
		case MAV_AUTOPILOT_SMACCMPILOT:
			return @"Smaccmpilot";
			break;
		case MAV_AUTOPILOT_AUTOQUAD:
			return @"Autoquad";
			break;
		case MAV_AUTOPILOT_ARMAZILA:
			return @"Armazila";
			break;
		case MAV_AUTOPILOT_AEROB:
			return @"Aerob";
			break;
		default:
			return @"---";
			break;
	}
	return @"---";
}


- (NSString*)getAutopilotImageNameByAutopilotID:(NSInteger)autopilotID
{
	switch (autopilotID) {
		case MAV_AUTOPILOT_GENERIC:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_PIXHAWK:
			return @"px4.png";
			break;
		case MAV_AUTOPILOT_SLUGS:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_ARDUPILOTMEGA:
			return @"apm.png";
			break;
		case MAV_AUTOPILOT_OPENPILOT:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_GENERIC_MISSION_FULL:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_INVALID:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_PPZ:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_UDB:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_FP:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_PX4:
			return @"px4.png";
			break;
		case MAV_AUTOPILOT_SMACCMPILOT:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_AUTOQUAD:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_ARMAZILA:
			return @"blank.png";
			break;
		case MAV_AUTOPILOT_AEROB:
			return @"blank.png";
			break;
		default:
			return @"blank.png";
			break;
	}
	return @"blank.png";
}


- (NSString*)getMAVTypeImageByID:(NSInteger)mavtypeID
{
	switch (mavtypeID) {
		case MAV_TYPE_GENERIC:
			return @"xxx";
			break;
		case MAV_TYPE_FIXED_WING:
			return @"xxx";
			break;
		case MAV_TYPE_QUADROTOR:
			return @"xxx";
			break;
		case MAV_TYPE_COAXIAL:
			return @"xxx";
			break;
		case MAV_TYPE_HELICOPTER:
			return @"xxx";
			break;
		case MAV_TYPE_ANTENNA_TRACKER:
			return @"xxx";
			break;
		case MAV_TYPE_GCS:
			return @"xxx";
			break;
		case MAV_TYPE_AIRSHIP:
			return @"xxx";
			break;
		case MAV_TYPE_FREE_BALLOON:
			return @"xxx";
			break;
		case MAV_TYPE_ROCKET:
			return @"xxx";
			break;
		case MAV_TYPE_GROUND_ROVER:
			return @"xxx";
			break;
		case MAV_TYPE_SURFACE_BOAT:
			return @"xxx";
			break;
		case MAV_TYPE_SUBMARINE:
			return @"xxx";
			break;
		case MAV_TYPE_HEXAROTOR:
			return @"xxx";
			break;
		case MAV_TYPE_OCTOROTOR:
			return @"xxx";
			break;
		case MAV_TYPE_TRICOPTER:
			return @"xxx";
			break;
		case MAV_TYPE_FLAPPING_WING:
			return @"xxx";
			break;
		case MAV_TYPE_KITE:
			return @"xxx";
			break;
		case MAV_TYPE_ONBOARD_CONTROLLER:
			return @"xxx";
			break;
		default:
			return @"xxx";
			break;
	}
	return @"xxx";
}


- (NSString*)getGPSFixTypeByID:(NSInteger)fixID
{
	switch (fixID) {
		case 0:
		case 1:
			return @"no";
			break;
		case 2:
			return @"2D";
			break;
		case 3:
			return @"3D";
			break;
		default:
			return @"no";
			break;
	}
	return @"no";
}

@end
