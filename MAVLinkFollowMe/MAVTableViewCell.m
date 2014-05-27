//
//  MAVTableViewCell.m
//  MAVLinkFollowMe
//
//  Created by marco on 20.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import "MAVTableViewCell.h"

@implementation MAVTableViewCell

@synthesize mtvc_AutopilotImage;
@synthesize mtvc_BackgroundImage;
@synthesize mtvc_txtAutopilot;
@synthesize mtvc_txtCompID;
@synthesize mtvc_txtSysID;

/*
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
