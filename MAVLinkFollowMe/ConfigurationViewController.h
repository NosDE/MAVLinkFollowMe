//
//  ConfigurationViewController.h
//  MAVLinkFollowMe
//
//  Created by marco on 20.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistentDataStore.h"
#import "DataModel.h"
#import "MAV.h"
#import "MAVTableViewCell.h"
#import "MAVHelper.h"

@interface ConfigurationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
        DataModel 			*model;
}

@property (weak, nonatomic) IBOutlet UILabel *lbl_numberOfMAVInList;
@property (weak, nonatomic) IBOutlet UITextField *txt_BridgeIP;
@property (weak, nonatomic) IBOutlet UITextField *txt_BridgePort;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
