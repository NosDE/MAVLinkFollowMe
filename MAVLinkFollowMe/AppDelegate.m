//
//  AppDelegate.m
//  MAVLinkFollowMe
//
//  Created by marco on 11.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //playSoundFXnamed: (NSString*) vSFXName Loop: (BOOL) vLoop
    
    [self playSoundFXnamed:@"px4-boot.aif" Loop:NO];

    [[PersistentDataStore getData] load];
    if ([[[PersistentDataStore getData] tcpHost] length] == 0) {
        [[PersistentDataStore getData] setTcpHost:@"10.0.0.1"];
        [[PersistentDataStore getData] save];
    }
    if (![[PersistentDataStore getData] tcpPort]) {
        [[PersistentDataStore getData] setTcpPort:2000];
        [[PersistentDataStore getData] save];
    }
 
    heartbeatLoopDelayCounter = HEARTBEAT_DELAY;
    
    model = [DataModel sharedModel];
    [model allocMAVArray];
    
    model.gcs_SystemID = 255;
    model.gcs_ComponentID = 190;
    
    model.glob_BridgeIP = [[PersistentDataStore getData] tcpHost];
    model.glob_BridgePort = [[PersistentDataStore getData] tcpPort];
//    model.glob_BridgeIP = @"10.0.0.1";
//    model.glob_BridgePort = 2000;
    model.glob_GPSMinAccuracy = 10;
    model.glob_MAVHeartbeatTimoutCounter = 0;
    model.glob_MAVHeartbeatTimoutCounterReloadValue = HEARTBEAT_TIMEOUT;
    model.glob_MAVHeartbeatLEDCounter = 0;
    model.glob_MAVHeartbeatLEDCounterReloadValue = HEARTBEAT_DELAY;
	model.glob_MAVHeartbeatToMAVEnabled = NO;
    model.glob_BridgeConnected = NO;
    model.glob_FollowMeEnabled = NO;
    model.glob_GCSInitState = GET_MAV_TYPE_STATUS_WAIT_HEARTBEAT;

   
    
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];


	NSError *error = nil;
	NSString *host = model.glob_BridgeIP;
	uint16_t port = model.glob_BridgePort;
    
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    model.asyncSocket = asyncSocket;
    
	if (![asyncSocket connectToHost:host onPort:port error:&error])
	{
		NSLog(@"Unable to connect");
	}
	else
	{
		NSLog(@"Connecting...");
	}

  
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];


	return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[PersistentDataStore getData] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[PersistentDataStore getData] save];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"GPS-Error");
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	// save location update in datastore
	CLLocation* location = [locations lastObject];
    model.gcs_location = location;
}



- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
	NSLog(@"Connected...");
    model.glob_BridgeConnected = YES;
    
	// start receiving data
	[asyncSocket readDataWithTimeout:-1 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSString *receivedData;
	receivedData = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
	static int packet_drops = 0;
    uint16_t batteryVoltage=0;
	mavlink_message_t msg;
	mavlink_status_t status;
	
	for (int i=0; i < [receivedData length]; i++) {
		if(mavlink_parse_char(MAVLINK_COMM_0, [receivedData characterAtIndex:i], &msg, &status)) {
            
			// Handle message
            MAV *tmpMAV = [[DataModel sharedModel] getMAVForUpdateWithSystemID:msg.sysid CompID:msg.compid];
			switch(msg.msgid)
			{
				case MAVLINK_MSG_ID_SET_MODE:
                {
                    NSLog(@"MAVLINK_MSG_ID_SET_MODE\r\n");
					tmpMAV.baseMode = mavlink_msg_set_mode_get_base_mode(&msg);
                    [[DataModel sharedModel] saveMAV:tmpMAV];
                    break;
                }
                    
				case MAVLINK_MSG_ID_GLOBAL_POSITION_INT:
                {
                    NSLog(@"MAVLINK_MSG_ID_GLOBAL_POSITION_INT\r\n");
                    mavlink_global_position_int_t pos;
                    mavlink_msg_global_position_int_decode(&msg, &pos);
					tmpMAV.gpsLat = pos.lat;
					tmpMAV.gpsLon = pos.lon;
					tmpMAV.gpsAlt = pos.relative_alt;
					tmpMAV.gpsHdg = pos.hdg;
					[[DataModel sharedModel] saveMAV:tmpMAV];
                    break;
                }
                    

				case MAVLINK_MSG_ID_GPS_RAW_INT:
                {
                    NSLog(@"MAVLINK_MSG_ID_GPS_RAW_INT\r\n");
                    mavlink_gps_raw_int_t gps;
                    mavlink_msg_gps_raw_int_decode(&msg, &gps);
					tmpMAV.gpsFix = gps.fix_type;
					tmpMAV.gpsNumberOfSatsInView = gps.satellites_visible;
					[[DataModel sharedModel] saveMAV:tmpMAV];
                    break;
                }

				
				case MAVLINK_MSG_ID_MISSION_ACK:
                {
                    NSLog(@"MAVLINK_MSG_ID_MISSION_ACK\r\n");
                    [self playSoundFXnamed:@"px4-ack.aif" Loop:NO];
                    break;
                }
                    
                case MAVLINK_MSG_ID_SYS_STATUS:
                {
                    NSLog(@"MAVLINK_MSG_ID_SYS_STATUS\r\n");
					tmpMAV.sysVoltage = mavlink_msg_sys_status_get_voltage_battery(&msg);
                    [[DataModel sharedModel] saveMAV:tmpMAV];
                    break;
                }
                    
				case MAVLINK_MSG_ID_PING:
				{
                    NSLog(@"Pingreply\r\n");
                    break;
                }
                    
                case MAVLINK_MSG_ID_COMMAND_ACK:
                {
                    mavlink_command_ack_t cmd;
                    mavlink_msg_command_ack_decode(&msg, &cmd);

                    NSLog(@"MAVLINK_MSG_ID_COMMAND_ACK\r\n");
                    [self playSoundFXnamed:@"px4-ack.aif" Loop:NO];

                    NSMutableString *messageTitle = @"MAV ACK";
                    NSMutableString *messageText = [NSString stringWithFormat:@"%d", cmd.result];
                    
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:messageTitle
                                               message:messageText
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
                    
                    [alert show];

                    break;
                }
                    
				case MAVLINK_MSG_ID_HEARTBEAT:
                {
                    NSLog(@"Heartbeat\r\n");
                    mavlink_heartbeat_t beat;
                    mavlink_msg_heartbeat_decode(&msg, &beat);
					NSString *timeStampValue = [NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]];
					tmpMAV.heartbeatLastTimestamp = timeStampValue;
					tmpMAV.heartbeatTimeoutCounter = model.glob_MAVHeartbeatTimoutCounterReloadValue;
					model.glob_MAVHeartbeatTimoutCounter = model.glob_MAVHeartbeatTimoutCounterReloadValue;
					tmpMAV.customMode = beat.custom_mode;
					tmpMAV.baseMode = beat.base_mode;
					tmpMAV.systemStatus = beat.system_status;
					tmpMAV.mavlinkVersion = beat.mavlink_version;
					tmpMAV.autopilotID = beat.autopilot;
					tmpMAV.mavtypeID = beat.type;
					
                    //[self saveMAV:tmpMAV];
                    [[DataModel sharedModel] saveMAV:tmpMAV];
                    break;
                }
                    

				case MAVLINK_MSG_ID_STATUSTEXT:
                {
                    mavlink_statustext_t statustext;
                    mavlink_msg_statustext_decode(&msg, &statustext);
                    NSString *stext = [[NSString alloc] initWithCString:statustext.text encoding:NSASCIIStringEncoding];
                    tmpMAV.textMessage = stext;
                    tmpMAV.textMessageAvail = YES;
                    [[DataModel sharedModel] saveMAV:tmpMAV];
                    NSLog(@"MAVLINK_MSG_ID_STATUSTEXT_253: %@\r\n", stext);
                    break;
                }

                    
                default:
				{
                    //Do nothing
                    NSLog(@"Mavlink Packet : %d\r\n", msg.msgid);
                    break;
                }
			}
            
		}
        
		// Update global packet drops counter
		packet_drops += status.packet_rx_drop_count;
        //model.mav_HeartbeatPacketsLost += status.packet_rx_drop_count;
        
    }
    
    // wait for more data
	[asyncSocket readDataWithTimeout:-1 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    model.glob_BridgeConnected = NO;
	NSLog(@"Disconnected\r\n");
}



- (void) tick:(NSTimer *) timer {
    
    mavlink_message_t msg;
 	char buf = malloc(MAVLINK_MAX_PACKET_LEN);
    uint8_t targetSystem = 0;
    uint8_t targetComponent = 0;

    
    // heartbeat -- start --
    if (heartbeatLoopDelayCounter == 0)
    {
        heartbeatLoopDelayCounter = HEARTBEAT_DELAY;
    
        if (model.glob_BridgeConnected == YES &&
            model.glob_MAVHeartbeatToMAVEnabled == YES)
        {
            if ([[DataModel sharedModel] getConnectedMAV])
            {
                MAV *curMAV = [[DataModel sharedModel] getConnectedMAV];

                mavlink_msg_heartbeat_pack(model.gcs_SystemID, model.gcs_ComponentID, &msg, curMAV.systemID, curMAV.componentID, 0, 0, 0);
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
            }
        }
    } else {
        heartbeatLoopDelayCounter--;
    }
    // heartbeat -- end --
 
    
    // do commands -- start --
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *curMAV = [[DataModel sharedModel] getConnectedMAV];
        
        switch (curMAV.cmdToMAV)
        {
            case CMD_TO_MAV_ENABLE_STREAMS:	// works
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                
                const uint8_t maxStreams = 2;
                const uint8_t MAVStreams[maxStreams] = {MAV_DATA_STREAM_ALL,
                    MAV_DATA_STREAM_EXTENDED_STATUS};
                const uint16_t MAVRates[maxStreams] = {6,1};
                for (int i=0; i<maxStreams; i++)
                {
                    mavlink_msg_request_data_stream_pack(model.gcs_SystemID, model.gcs_ComponentID, &msg, targetSystem, targetComponent, MAVStreams[i], MAVRates[i], 1);
                    uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                    NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                    curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                    [[DataModel sharedModel] saveMAV:curMAV];
                    [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                }
                break;
            }
                
            
            case CMD_TO_MAV_DISABLE_STREAMS:	// works
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                
                const uint8_t maxStreams = 2;
                const uint8_t MAVStreams[maxStreams] = {MAV_DATA_STREAM_ALL,
                    MAV_DATA_STREAM_EXTENDED_STATUS};
                const uint16_t MAVRates[maxStreams] = {6,1};
                
                for (int i=0; i<maxStreams; i++)
                {
                    mavlink_msg_request_data_stream_pack(model.gcs_SystemID, model.gcs_ComponentID, &msg, targetSystem, targetComponent, MAVStreams[i], MAVRates[i], 0);
                    uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                    NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                    curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                    [[DataModel sharedModel] saveMAV:curMAV];
                    [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                }
                break;
            }
        
            
            case CMD_TO_MAV_LAND:	// works
            {
                NSLog(@"FollowMe: land\r\n");
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                
                mavlink_msg_set_mode_pack(model.gcs_SystemID, model.gcs_ComponentID, &msg, targetSystem, targetComponent, 9);
                
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }
                

            case CMD_TO_MAV_FLY_TO:	// wip
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                
                CLLocation* location = model.gcs_location;
                double lat, lon, alt, hdg;
                NSString *connection_text = @"";
                
                lat = location.coordinate.latitude;
                lon = location.coordinate.longitude;
                alt = curMAV.gpsAlt;
                hdg = curMAV.gpsHdg;
                
                //float _xf = (float) lat * (float) 1e7;	/* lat, lon in deg * 10,000,000 */
                //float _yf = (float) lon * (float) 1e7;	/* lat, lon in deg * 10,000,000 */
                
                NSLog(@"FollowMe: guide x:%f y:%f z:%f\r\n", lat, lon);

				mavlink_msg_mission_item_pack(	model.gcs_SystemID, 
												model.gcs_ComponentID, 
												&msg,
												targetSystem, 
												targetComponent,
												0, 						/* uint16_t seq: always 0, unknown why. */
												MAV_FRAME_GLOBAL,		/* uint8_t frame: arducopter uninterpreted */
												MAV_CMD_NAV_WAYPOINT, 	/* uint16_t command: arducopter specific */
												2, 						/* uint8_t current: 2 indicates guided mode waypoint */
												0, 						/* uint8_t autocontinue: always 0 */
												0, 						/* float param1 : hold time in seconds */
												5, 						/* float param2 : acceptance radius in meters */
												0, 						/* float param3 : pass through waypoint */
												0, 						/* float param4 : desired yaw angle at waypoint */
												lat, 					/* float x : lat degrees */
												lon, 					/* float y : lon degrees */
												alt  					/* float z : alt meters */
											);
											
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }


            case CMD_TO_MAV_RTL:	// wip
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                NSString *connection_text = @"";
                NSLog(@"CMD_TO_MAV_RTL");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID, 
												model.gcs_ComponentID, 
												&msg,
												targetSystem, 
												targetComponent, 
												MAV_CMD_NAV_RETURN_TO_LAUNCH, 
												0, 
												0, 
												0, 
												0, 
												0, 
												0, 
												0, 
												0
											);
											  
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }

                
            case CMD_TO_MAV_CLIMB:	// wip not supported
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                
                double lat, lon, alt, hdg;
                
                lat = curMAV.gpsLat;
                lon = curMAV.gpsLon;
                alt = curMAV.gpsAlt;
                hdg = curMAV.gpsHdg;
                
                alt = alt+1000;
                
                NSLog(@"FollowMe: climb \r\n");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID, 
												model.gcs_ComponentID, 
												&msg,
												targetSystem, 
												targetComponent, 
												MAV_CMD_CONDITION_CHANGE_ALT, 
												0, 
												0.5, 				/* Descent / Ascend rate (m/s) */
												0, 
												0, 
												0, 
												0, 
												0, 
												alt					/* altitude */
											);
											  
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }
                

            case CMD_TO_MAV_DESCENT:	// wip not supported
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                
                double lat, lon, alt, hdg;
                
                lat = curMAV.gpsLat;
                lon = curMAV.gpsLon;
                alt = curMAV.gpsAlt;
                hdg = curMAV.gpsHdg;
                
                alt = alt-1000;
                
                NSLog(@"FollowMe: descent \r\n");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID, 
												model.gcs_ComponentID, 
												&msg,
												targetSystem, 
												targetComponent, 
												MAV_CMD_CONDITION_CHANGE_ALT, 
												0, 
												0.5, 				/* Descent / Ascend rate (m/s) */
												0, 
												0, 
												0, 
												0, 
												0, 
												alt					/* altitude */
											);
                
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }

            
            case CMD_TO_MAV_LOITER:		// wip
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                
                NSLog(@"FollowMe: loiter \r\n");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID, 
												model.gcs_ComponentID, 
												&msg,
												targetSystem, 
												targetComponent, 
												MAV_CMD_NAV_LOITER_UNLIM, 
												0, 
												0, 
												0, 
												0,					/* float param3 : acceptance radius in meters */ 
												0, 				/* float param4 : desired yaw angle at waypoint */
												0, 				/* float x : lat degrees */
												0, 				/* float y : lon degrees */
												0					/* float z : alt meters */
											);
											  
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }

			
            case CMD_TO_MAV_CALIBRATE_MAG:	// ok
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                NSString *connection_text = @"";
                NSLog(@"CMD_TO_MAV_CALIBRATE_MAG");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID,
                                              model.gcs_ComponentID,
                                              &msg,
                                              targetSystem,
                                              targetComponent,
                                              MAV_CMD_PREFLIGHT_CALIBRATION,
                                              0,
                                              0,
                                              1,
                                              0,
                                              0,
                                              0,
                                              0,
                                              0
                                              );
                
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }

                
            case CMD_TO_MAV_CALIBRATE_ACC:	// ok
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                NSString *connection_text = @"";
                NSLog(@"CMD_TO_MAV_CALIBRATE_ACC");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID,
                                              model.gcs_ComponentID,
                                              &msg,
                                              targetSystem,
                                              targetComponent,
                                              MAV_CMD_PREFLIGHT_CALIBRATION,
                                              0,
                                              0,
                                              0,
                                              0,
                                              0,
                                              1,
                                              0,
                                              0
                                              );
                
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }

           
            case CMD_TO_MAV_CALIBRATE_GYRO:	// ok
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                NSString *connection_text = @"";
                NSLog(@"CMD_TO_MAV_CALIBRATE_GYRO");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID,
                                              model.gcs_ComponentID,
                                              &msg,
                                              targetSystem,
                                              targetComponent,
                                              MAV_CMD_PREFLIGHT_CALIBRATION,
                                              0,
                                              1,
                                              0,
                                              0,
                                              0,
                                              0,
                                              0,
                                              0
                                              );
                
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }

                
            case CMD_TO_MAV_SAVE_PARAMS:	// wip
            {
                targetSystem = curMAV.systemID;
                targetComponent = curMAV.componentID;
                NSString *connection_text = @"";
                NSLog(@"CMD_TO_MAV_SAVE_PARAMS");
                
				mavlink_msg_command_long_pack(	model.gcs_SystemID,
                                              model.gcs_ComponentID,
                                              &msg,
                                              targetSystem,
                                              targetComponent,
                                              MAV_CMD_PREFLIGHT_STORAGE,
                                              0,
                                              1,
                                              0,
                                              0,
                                              0,
                                              0,
                                              0,
                                              0
                                              );
                
                uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                curMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                [[DataModel sharedModel] saveMAV:curMAV];
                [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                break;
            }
                
            
            case CMD_TO_MAV_NO_CMD:
            {
                //NSLog(@"Idle sysID:%d compID:%d", curMAV.systemID, curMAV.componentID);
                
            }
                
            default:
            {
                // nothing to do here
            }
                
        }
        
    }
    
    
 
    
    NSArray *mavList = model.mavArray;
    if ([mavList count] > 0) {
		for (MAV *objMAV in mavList) {
            if (objMAV.cmdToMAV == CMD_TO_MAV_DISABLE_STREAMS) {

                targetSystem = objMAV.systemID;
                targetComponent = objMAV.componentID;
                
                const uint8_t maxStreams = 2;
                const uint8_t MAVStreams[maxStreams] = {MAV_DATA_STREAM_ALL,
                    MAV_DATA_STREAM_EXTENDED_STATUS};
                const uint16_t MAVRates[maxStreams] = {6,1};
                
                for (int i=0; i<maxStreams; i++)
                {
                    mavlink_msg_request_data_stream_pack(model.gcs_SystemID, model.gcs_ComponentID, &msg, targetSystem, targetComponent, MAVStreams[i], MAVRates[i], 0);
                    uint16_t len = mavlink_msg_to_send_buffer(&buf, &msg);
                    NSData *mavOutData = [NSData dataWithBytes:&buf length:len];
                    objMAV.cmdToMAV = CMD_TO_MAV_NO_CMD;
                    //[self saveMAV:objMAV];
                    [[DataModel sharedModel] saveMAV:objMAV];
                    NSLog(@"Disable sysID:%d compID:%d Stream:%d", objMAV.systemID, objMAV.componentID, i);
                    [asyncSocket writeData:mavOutData withTimeout:5.0 tag:0];
                }

            
            }
		}
	}
    
}



-(BOOL) playSoundFXnamed: (NSString*) vSFXName Loop: (BOOL) vLoop
{
    NSError *error;
    
    NSBundle* bundle = [NSBundle mainBundle];
    
    NSString* bundleDirectory = (NSString*)[bundle bundlePath];
    
    NSURL *url = [NSURL fileURLWithPath:[bundleDirectory stringByAppendingPathComponent:vSFXName]];
    
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if(vLoop)
        audioPlayer.numberOfLoops = -1;
    else
        audioPlayer.numberOfLoops = 0;
    
    BOOL success = YES;
    
    if (audioPlayer == nil)
    {
        success = NO;
    }
    else
    {
        success = [audioPlayer play];
    }
    
    
    return success;
}



@end
