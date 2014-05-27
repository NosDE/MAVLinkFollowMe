//
//  AppDelegate.h
//  MAVLinkFollowMe
//
//  Created by marco on 11.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "GCDAsyncSocket.h"
#import "PersistentDataStore.h"
#import "DataModel.h"
#import "mavlink.h"
#import "MAV.h"
#import "GPSHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
	CLLocationManager 	*locationManager;
    GCDAsyncSocket 		*asyncSocket;
	DataModel 			*model;
    AVAudioPlayer       *audioPlayer;
}
@property (strong, nonatomic) UIWindow *window;


@end
