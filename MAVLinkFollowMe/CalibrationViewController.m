//
//  CalibrationViewController.m
//  MAVLinkFollowMe
//
//  Created by marco on 25.05.14.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

#import "CalibrationViewController.h"

@interface CalibrationViewController ()

@end

@implementation CalibrationViewController

@synthesize lblTextMessage;


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
    
    
    model = [DataModel sharedModel];
    
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
    
    /**********************************************************************
     hande all things if mav is connected
     *********************************************************************/
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
    
        if (currMAV.textMessageAvail == YES) {
            lblTextMessage.text = currMAV.textMessage;
            currMAV.textMessageAvail = NO;
            currMAV.textMessage = @"";
            [[DataModel sharedModel] saveMAV:currMAV];
        }
        
    }
}

- (IBAction)btnGyro:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_CALIBRATE_GYRO;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}

- (IBAction)btnMag:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_CALIBRATE_MAG;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}

- (IBAction)btnAcc:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_CALIBRATE_ACC;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}

- (IBAction)btnSave:(id)sender {
    if ([[DataModel sharedModel] getConnectedMAV])
    {
        MAV *currMAV = [[DataModel sharedModel] getConnectedMAV];
        currMAV.cmdToMAV = CMD_TO_MAV_SAVE_PARAMS;
        [[DataModel sharedModel] saveMAV:currMAV];
    } else {
        NSLog(@"No MAV connected...");
    }
}




@end
