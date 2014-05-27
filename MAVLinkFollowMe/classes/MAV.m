#import "MAV.h"

@implementation MAV

@synthesize mavNumber;
@synthesize mavIsInUse;
@synthesize cmdToMAV;

@synthesize systemID;
@synthesize componentID;
@synthesize autopilotID;
@synthesize mavtypeID;

@synthesize systemStatus;
@synthesize mavlinkVersion;
@synthesize customMode;
@synthesize baseMode;
@synthesize heartbeatLastTimestamp;
@synthesize heartbeatTimeoutCounter;

@synthesize gpsLat;
@synthesize gpsLon;
@synthesize gpsAlt;
@synthesize gpsHdg;
@synthesize sysVoltage;
@synthesize gpsFix;
@synthesize gpsNumberOfSatsInUse;
@synthesize gpsNumberOfSatsInView;
@synthesize heartbeatPacketsLost;

@synthesize textMessageAvail;
@synthesize textMessage;


- (id)initValues
{
    self = [super init];

    if (self) {
		self.mavNumber = 0;
		self.mavIsInUse = NO;
		self.cmdToMAV = 0;
		self.systemID = 0;
		self.componentID = 0;
		self.autopilotID = 0;
		self.mavtypeID = 0;
		self.systemStatus = 0;
		self.mavlinkVersion = 0;
		self.customMode = 0;
		self.baseMode = 0;
		self.heartbeatLastTimestamp = 0;
		self.gpsLat = 0;
		self.gpsLon = 0;
		self.gpsAlt = 0;
		self.gpsHdg = 0;
		self.sysVoltage = 0;
		self.gpsFix = 0;
		self.gpsNumberOfSatsInUse = 0;
		self.gpsNumberOfSatsInView = 0;
		self.heartbeatPacketsLost = 0;
		self.heartbeatTimeoutCounter = 0;
        self.textMessageAvail = NO;
        self.textMessage = @"";
	}
    return self;
}

@end
