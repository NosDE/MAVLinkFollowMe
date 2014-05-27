//
//  ConfigurationViewController.m
//  MAVLinkFollowMe
//
//  Created by marco on 20.04.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import "ConfigurationViewController.h"


@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

@synthesize lbl_numberOfMAVInList;
@synthesize txt_BridgeIP;
@synthesize txt_BridgePort;


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
    lbl_numberOfMAVInList.text = [NSString stringWithFormat:@"%d", [model.mavArray count]];
    txt_BridgeIP.text = model.glob_BridgeIP;
    txt_BridgePort.text = [NSString stringWithFormat:@"%d", model.glob_BridgePort];
    

    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 0;
    return [model.mavArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([model.mavArray count]> indexPath.row)
    {
        MAV *curMAV = [model.mavArray objectAtIndex:indexPath.row];
        static NSString *mavTableIdentifier = @"SimpleTableCell";
        
        MAVTableViewCell *cell = (MAVTableViewCell *)[tableView dequeueReusableCellWithIdentifier:mavTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MAVTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.mtvc_txtSysID.text = [NSString stringWithFormat:@"%d",curMAV.systemID];
        cell.mtvc_txtCompID.text = [NSString stringWithFormat:@"%d",curMAV.componentID];
        cell.mtvc_txtAutopilot.text = [[MAVHelper alloc] getAutopilotNameByAutopilotID:curMAV.autopilotID];
        
        cell.imageView.image = [UIImage imageNamed: [[MAVHelper alloc] getAutopilotImageNameByAutopilotID:curMAV.autopilotID]];
        return cell;
    
    
    }
    return 0;
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    NSArray *mavArr = model.mavArray;
    NSInteger arrLoopCounter = 0;
    
	if ([mavArr count] > 0) {
		for (MAV *objMAV in mavArr) {
			if (objMAV.mavNumber == indexPath.row) {
                objMAV.cmdToMAV = CMD_TO_MAV_ENABLE_STREAMS;
                objMAV.mavIsInUse = YES;
            } else {
                objMAV.cmdToMAV = CMD_TO_MAV_DISABLE_STREAMS;
                objMAV.mavIsInUse = NO;
            }
            [[DataModel sharedModel] saveMAV:objMAV];
            arrLoopCounter++;
        }
 	}
    
    NSLog(@"%d", indexPath.row);
    return indexPath ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (IBAction)btnSaveClick:(id)sender {

    model.glob_BridgeIP = txt_BridgeIP.text;
    model.glob_BridgePort = [txt_BridgePort.text intValue];

    [[PersistentDataStore getData] load];
    [[PersistentDataStore getData] setTcpHost:model.glob_BridgeIP];
    [[PersistentDataStore getData] setTcpPort:model.glob_BridgePort];
    [[PersistentDataStore getData] save];
    
    NSMutableString *messageTitle = @"Settings";
    NSMutableString *messageText = @"saved...";
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:messageTitle
                        message:messageText
                        delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)btnClearClick:(id)sender {

    NSArray *mavArr = model.mavArray;
	
	if ([mavArr count] > 0) {
		for (MAV *objMAV in mavArr) {
            objMAV.cmdToMAV = CMD_TO_MAV_DISABLE_STREAMS;
            objMAV.mavIsInUse = NO;
            [[DataModel sharedModel] saveMAV:objMAV];
		}
        
    }

    
    NSMutableString *messageTitle = @"MAV Streams";
    NSMutableString *messageText = @"All MAV Streams will be reset to their default values (Heartbeat)";
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:messageTitle
                               message:messageText
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    
    [alert show];

}

- (IBAction)bridgeIP:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)bridgePort:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)btnRefreshClick:(id)sender {
    [self.tableView reloadData];
}


@end
