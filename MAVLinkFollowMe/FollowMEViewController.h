//
//  FollowMEViewController.h
//  MAVLinkFollowMe
//
//  Created by marco on 12.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mavlink.h"
#import "DataModel.h"
#import <AVFoundation/AVFoundation.h>
#import "MAVHelper.h"


#define PING_UPDATE_DELAY 5	// delay x 0.2 sec = 2 sec
#define TIMER_RESOLUTION 0.5
#define HEARTBEAT_TIMEOUT 10    // 3 sec
#define HEARTBEAT_DELAY 2

@interface FollowMEViewController : UIViewController
{
    BOOL boolHeartBeatButtonVisible;
    GCDAsyncSocket *asyncSocket;
    DataModel *model;

}


@property (weak, nonatomic) IBOutlet UILabel *lblBridgeConnectionStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblMAVConnectionStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectedSysID;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectedCompID;

@property (weak, nonatomic) IBOutlet UILabel *lblMAVinRange;
@property (weak, nonatomic) IBOutlet UILabel *lblBatteryVoltage;
@property (weak, nonatomic) IBOutlet UILabel *lblHeartbeatLostCounter;

@property (weak, nonatomic) IBOutlet UILabel *lblMAVAutopilotType;
@property (weak, nonatomic) IBOutlet UILabel *lblMAVGPSLat;
@property (weak, nonatomic) IBOutlet UILabel *lblMAVGPSLon;
@property (weak, nonatomic) IBOutlet UILabel *lblMAVGPSAlt;
@property (weak, nonatomic) IBOutlet UILabel *lblMAVGPSHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblMAVGPSFixType;
@property (weak, nonatomic) IBOutlet UILabel *lblMAVGPSNumberOfSatsInView;


@property (weak, nonatomic) IBOutlet UILabel *locLat;
@property (weak, nonatomic) IBOutlet UILabel *locLng;
@property (weak, nonatomic) IBOutlet UILabel *locAccuracy;




@property (weak, nonatomic) IBOutlet UIButton *img_led_green;
@property (weak, nonatomic) IBOutlet UIButton *img_led_grey;

- (IBAction)switchFollowMe:(id)sender;


@end
