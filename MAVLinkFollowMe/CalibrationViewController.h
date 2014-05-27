//
//  CalibrationViewController.h
//  MAVLinkFollowMe
//
//  Created by marco on 25.05.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mavlink.h"
#import "DataModel.h"
#import <AVFoundation/AVFoundation.h>
#import "MAVHelper.h"


#define TIMER_RESOLUTION 0.2

@interface CalibrationViewController : UIViewController
{
    DataModel *model;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTextMessage;

@end
