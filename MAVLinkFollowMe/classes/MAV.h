#import <Foundation/Foundation.h>

@interface MAV : NSObject 


@property(nonatomic) uint8_t			mavNumber;
@property(nonatomic) BOOL               mavIsInUse;
@property(nonatomic) uint8_t            cmdToMAV;
@property(nonatomic) uint8_t			systemID;
@property(nonatomic) uint8_t			componentID;
@property(nonatomic) uint8_t			autopilotID;
@property(nonatomic) uint8_t			mavtypeID;
@property(nonatomic) uint8_t			systemStatus;
@property(nonatomic) uint8_t			mavlinkVersion;
@property(nonatomic) uint32_t			customMode;
@property(nonatomic) uint8_t			baseMode;
@property(nonatomic) NSString 			*heartbeatLastTimestamp;
@property(nonatomic) uint8_t			heartbeatTimeoutCounter;

@property (nonatomic) double			gpsLat;
@property (nonatomic) double			gpsLon;
@property (nonatomic) double			gpsAlt;
@property (nonatomic) double			gpsHdg;
@property (nonatomic) double			sysVoltage;
@property (nonatomic) uint8_t			gpsFix;
@property (nonatomic) uint8_t			gpsNumberOfSatsInUse;
@property (nonatomic) uint8_t			gpsNumberOfSatsInView;
@property (nonatomic) uint8_t			heartbeatPacketsLost;

@property (nonatomic) BOOL              textMessageAvail;
@property (nonatomic) NSString          *textMessage;

- (id)initValues;


@end
