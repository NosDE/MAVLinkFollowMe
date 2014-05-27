#import <foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "GCDAsyncSocket.h"
#import "MAV.h"

#define SND_CMD_ACK 1016
#define SND_CMD_FOLLOWME 1104
#define HEARTBEAT_TIMEOUT 10    // 3 sec
#define HEARTBEAT_DELAY 2

uint8_t heartbeatLoopDelayCounter;

// NSString *string = [DataModel sharedModel].someProperty;

@interface DataModel: NSObject

@property (nonatomic) GCDAsyncSocket	        *asyncSocket;
@property (nonatomic) NSMutableArray            *mavArray;

@property (nonatomic) CLLocation	            *gcs_location;
@property (nonatomic) CMAcceleration            *gcs_acceleration;
@property (nonatomic) CMRotationRate            *gcs_rotation;
@property (nonatomic) uint8_t					gcs_SystemID;
@property (nonatomic) uint8_t					gcs_ComponentID;

@property (nonatomic) uint8_t					glob_GPSMinAccuracy;
@property (nonatomic) BOOL						glob_MAVHeartbeatToMAVEnabled;
@property (nonatomic) uint8_t					glob_MAVHeartbeatTimoutCounter;
@property (nonatomic) uint8_t					glob_MAVHeartbeatTimoutCounterReloadValue;
@property (nonatomic) uint8_t					glob_MAVHeartbeatLEDCounter;
@property (nonatomic) uint8_t					glob_MAVHeartbeatLEDCounterReloadValue;
@property (nonatomic) BOOL						glob_BridgeConnected;
@property (nonatomic) NSString					*glob_BridgeIP;
@property (nonatomic) uint16_t					glob_BridgePort;
@property (nonatomic) BOOL						glob_FollowMeEnabled;
@property (nonatomic) uint8_t					glob_GCSInitState;


+ (id)sharedModel;
- (void) allocMAVArray;
- (MAV*) getConnectedMAV;
- (void) saveMAV:(MAV*)curMAV;
- (MAV*) getMAVForUpdateWithSystemID:(uint8_t)systemID CompID:(uint8_t)componentID;


typedef NS_ENUM(NSUInteger, GetMAVTypeStatus) {
    GET_MAV_TYPE_STATUS_WAIT_HEARTBEAT,
    GET_MAV_TYPE_STATUS_HEARTBEAT,
    GET_MAV_TYPE_STATUS_DONE
};

typedef NS_ENUM(NSUInteger, SendToMAVCMD	) {
    CMD_TO_MAV_NO_CMD,
    CMD_TO_MAV_HEARTBEAT,
    CMD_TO_MAV_ENABLE_STREAMS,
    CMD_TO_MAV_DISABLE_STREAMS,
    CMD_TO_MAV_PING,
    CMD_TO_MAV_TAKEOFF,
    CMD_TO_MAV_LAND,
    CMD_TO_MAV_LOITER,
    CMD_TO_MAV_RTL,
    CMD_TO_MAV_FLY_TO,
    CMD_TO_MAV_CLIMB,
    CMD_TO_MAV_DESCENT,
    CMD_TO_MAV_CALIBRATE_ACC,
    CMD_TO_MAV_CALIBRATE_GYRO,
    CMD_TO_MAV_CALIBRATE_MAG,
    CMD_TO_MAV_SAVE_PARAMS
};


@end


