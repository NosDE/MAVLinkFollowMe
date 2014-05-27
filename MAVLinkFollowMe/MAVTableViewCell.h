//
//  MAVTableViewCell.h
//  MAVLinkFollowMe
//
//  Created by marco on 20.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAVTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *mtvc_BackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *mtvc_AutopilotImage;


@property (weak, nonatomic) IBOutlet UILabel *mtvc_txtAutopilot;
@property (weak, nonatomic) IBOutlet UILabel *mtvc_txtSysID;
@property (weak, nonatomic) IBOutlet UILabel *mtvc_txtCompID;

@end
