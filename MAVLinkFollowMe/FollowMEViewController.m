//
//  FollowMEViewController.m
//  MAVLinkFollowMe
//
//  Created by marco on 12.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import "FollowMEViewController.h"

@interface FollowMEViewController ()

@end

@implementation FollowMEViewController

@synthesize img_led_green;
@synthesize img_led_grey;

@synthesize lblMAVinRange;
@synthesize lblMAVConnectionStatus;
@synthesize lblBridgeConnectionStatus;
@synthesize lblConnectedSysID;
@synthesize lblConnectedCompID;
@synthesize lblBatteryVoltage;
@synthesize lblHeartbeatLostCounter;
@synthesize lblMAVAutopilotType;
@synthesize lblMAVGPSLat;
@synthesize lblMAVGPSLon;
@synthesize lblMAVGPSAlt;
@synthesize lblMAVGPSFixType;
@synthesize lblMAVGPSHeading;
@synthesize lblMAVGPSNumberOfSatsInView;

@synthesize locAccuracy;
@synthesize locLat;
@synthesize locLng;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    model = [DataModel sharedModel];
    asyncSocket = model.asyncSocket;
    
    boolHeartBeatButtonVisible = NO;
    
    
   	[NSTimer scheduledTimerWithTimeInterval:TIMER_RESOLUTION
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) tick:(NSTimer *) timer {

    CLLocation* location = model.gcs_location;
	double lat, lon, alt, accuracy;
    
	lat = location.coordinate.latitude;
	lon = location.coordinate.longitude;
	alt = location.altitude;
	accuracy = location.horizontalAccuracy;
    
	locAccuracy.text = [NSString stringWithFormat:@"%.0f", accuracy];
	locLat.text = [NSString stringWithFormat:@"%.7f", lat];
	locLng.text = [NSString stringWithFormat:@"%.7f", lon];

    
    /**********************************************************************
        hande connection status of the bridge
     *********************************************************************/
    if (model.glob_BridgeConnected == YES)
    {
        lblBridgeConnectionStatus.text = @"connected";
    }
    else
    {
        lblBridgeConnectionStatus.text = @"disconnected";
    }
    
    /**********************************************************************
        hande number ov mav in range (multinode)
     *********************************************************************/
    NSArray *mavARR = model.mavArray;
    lblMAVinRange.text = [NSString stringWithFormat:@"%d", [mavARR count]];

    
    
    /**********************************************************************
        hande all things if mav is connected
     *********************************************************************/
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        //MAV *currMAV = [self getConnectedMAV];
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        lblMAVConnectionStatus.text = @"connected";
        lblConnectedSysID.text = [NSString stringWithFormat:@"%d", currMAV.systemID];
        lblConnectedCompID.text = [NSString stringWithFormat:@"%d", currMAV.componentID];
        lblBatteryVoltage.text = [NSString stringWithFormat:@"%.1f", currMAV.sysVoltage/1000];
        lblHeartbeatLostCounter.text = [NSString stringWithFormat:@"%d", currMAV.heartbeatPacketsLost];
        lblMAVAutopilotType.text = [[MAVHelper alloc] getAutopilotNameByAutopilotID:currMAV.autopilotID];
        lblMAVGPSLat.text = [NSString stringWithFormat:@"%.7f", currMAV.gpsLat/1e7];
        lblMAVGPSLon.text = [NSString stringWithFormat:@"%.7f", currMAV.gpsLon/1e7];
        lblMAVGPSAlt.text = [NSString stringWithFormat:@"%.2f", currMAV.gpsAlt/1000];
        lblMAVGPSHeading.text = [NSString stringWithFormat:@"%d", @(currMAV.gpsHdg/100).intValue];
		lblMAVGPSFixType.text = [[MAVHelper alloc] getGPSFixTypeByID:currMAV.gpsFix];
        lblMAVGPSNumberOfSatsInView.text = [NSString stringWithFormat:@"%d", currMAV.gpsNumberOfSatsInView];
        
        
    	// do heartbeat
        if (currMAV.heartbeatTimeoutCounter > 0) {
            currMAV.heartbeatTimeoutCounter--;
            [[DataModel sharedModel] saveMAV:currMAV];
            //lbl_heartbeat.text = @"OK";
            if (model.glob_MAVHeartbeatLEDCounter == 0) {
                
                if (boolHeartBeatButtonVisible == NO) {
                    boolHeartBeatButtonVisible = YES;
                    [self heartBeatButtonFadeIn];
                } else {
                    boolHeartBeatButtonVisible = NO;
                    [self heartBeatButtonFadeOut];
                }
                
                model.glob_MAVHeartbeatLEDCounter = model.glob_MAVHeartbeatLEDCounterReloadValue;
                
            }
            model.glob_MAVHeartbeatLEDCounter--;
            
        } else {
            //lbl_heartbeat.text = @"";
            [self heartBeatButtonFadeOut];
        }

        if (model.glob_FollowMeEnabled == YES && currMAV.cmdToMAV == CMD_TO_MAV_NO_CMD && accuracy <= 10) {
            currMAV.cmdToMAV = CMD_TO_MAV_FLY_TO;
            [[DataModel sharedModel] saveMAV:currMAV];
        }
        
    }
    else
    {
        [self heartBeatButtonFadeOut];
        lblMAVConnectionStatus.text = @"disconnected";
        lblConnectedSysID.text = @"-";
        lblConnectedCompID.text = @"-";
        lblBatteryVoltage.text = @"--.--";
        lblHeartbeatLostCounter.text = @"-";
  
        lblMAVAutopilotType.text = @"";
        lblMAVGPSLat.text = @"---";
        lblMAVGPSLon.text = @"---";
        lblMAVGPSAlt.text = @"---";
        lblMAVGPSHeading.text = @"-";
        lblMAVGPSFixType.text = @"---";
        lblMAVGPSNumberOfSatsInView.text = @"--";


    }

    
}



- (void) sendMavlinkData:(NSUInteger)cmd
{
    mavlink_message_t msg;

    
}



- (void) heartBeatButtonFadeOut
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [img_led_green setAlpha:0.0f]; //or 1.0f
    [img_led_grey setAlpha:0.5f]; //or 1.0f
    [UIView commitAnimations];
    
}


- (void) heartBeatButtonFadeIn
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [img_led_green setAlpha:1.0f]; //or 1.0f
    [img_led_grey setAlpha:0.0f]; //or 1.0f
    [UIView commitAnimations];
    
}


- (IBAction)switchFollowMe:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
		if (model.glob_FollowMeEnabled == NO) {
			model.glob_FollowMeEnabled = YES;
		} else {
			model.glob_FollowMeEnabled = NO;
			MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
			currMAV.cmdToMAV = CMD_TO_MAV_LOITER;
			[[DataModel sharedModel] saveMAV:currMAV];
		}
    } else {
        NSLog(@"No MAV connected...");
    }

}

- (IBAction)btnLand:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_LAND;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}


- (IBAction)btnFlyToMe:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_FLY_TO;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}


- (IBAction)btnUp:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_CLIMB;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}


- (IBAction)btnDown:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_DESCENT;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}


- (IBAction)btnPosHold:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_LOITER;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}


- (IBAction)btnRTL:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_RTL;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}





@end
