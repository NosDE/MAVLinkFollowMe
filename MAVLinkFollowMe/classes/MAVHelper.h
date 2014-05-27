//
//  MAVHelper.h
//  MAVLinkFollowMe
//
//  Created by marco on 21.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mavlink.h"

@interface MAVHelper : NSObject

- (NSString*)getAutopilotNameByAutopilotID:(NSInteger)autopilotID;
- (NSString*)getAutopilotImageNameByAutopilotID:(NSInteger)autopilotID;
- (NSString*)getMAVTypeImageByID:(NSInteger)mavtypeID;
- (NSString*)getGPSFixTypeByID:(NSInteger)fixID;

@end
