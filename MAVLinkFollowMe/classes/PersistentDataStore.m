//
//  PersistentDataStore.m
//
//  Created by Marco Bauer on 06.04.2014.
//  Copyright (c) 2014 de.wtns. All rights reserved.
//

//    [[PersistentDataStore getData] load];
//    if ([[[PersistentDataStore getData] deviceID] length] == 0) {
//        [[PersistentDataStore getData] setDeviceID:ident];
//    }
//    [[PersistentDataStore getData] save];

#import "PersistentDataStore.h"

@implementation PersistentDataStore


@synthesize tcpPort;
@synthesize tcpHost;


static PersistentDataStore *_sharedContext = nil;

+ (PersistentDataStore *) getData
{
    if (!_sharedContext) {
        _sharedContext = [[self alloc] init];
    }
    return _sharedContext;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeDouble:self.tcpPort forKey:@"tcpPort"];
    [coder encodeObject:self.tcpHost forKey:@"tcpHost"];
}

-(id)initWithCoder:(NSCoder *)coder {

    if((self = [super init])) {	
	 	self.tcpPort = [coder decodeDoubleForKey:@"tcpPort"];
	 	self.tcpHost = [coder decodeObjectForKey:@"tcpHost"];
    }
    return self;
}

-(void)save{
    // save Data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PersistentDataStore *model = [PersistentDataStore getData];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [defaults setObject:data forKey:@"DataStore"];
    [defaults synchronize];   
}

-(void)load{    
   // Load User Settings
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [defaults objectForKey:@"DataStore"];
	PersistentDataStore *gXpertData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	if(gXpertData != NULL) {
		PersistentDataStore *model = [PersistentDataStore getData];
		model.tcpPort = gXpertData.tcpPort;
		model.tcpHost = gXpertData.tcpHost;
   }
}


@end

