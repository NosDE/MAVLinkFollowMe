#import "DataModel.h"

@implementation DataModel

+ (id)sharedModel {
    static DataModel *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}



- (void) allocMAVArray
{
    _mavArray = [[NSMutableArray alloc] init];
}



- (MAV*) getConnectedMAV {
    NSArray *tmpMAVArr = _mavArray;
    
    for (MAV * objMAV in tmpMAVArr) {
        if (objMAV.mavIsInUse == YES) {
            return objMAV;
        }
    }
    
    return FALSE;
}



- (void) saveMAV:(MAV*)curMAV {
    BOOL MAVFoundInArray = NO;
    NSArray *mavArr = _mavArray;
    NSMutableArray *tmpMAVArr = [[NSMutableArray alloc] init];
    
	if ([mavArr count] > 0) {
		for (MAV *objMAV in mavArr) {
			if (objMAV.systemID == curMAV.systemID && objMAV.componentID == curMAV.componentID) {
                MAVFoundInArray = YES;
			}
            [tmpMAVArr addObject:objMAV];
		}
        
        if (MAVFoundInArray == NO){
            curMAV.mavNumber = [mavArr count];
            [tmpMAVArr addObject:curMAV];
        }
        
	} else {
        curMAV.mavNumber = [mavArr count];
        [tmpMAVArr addObject:curMAV];
	}
    
    _mavArray = tmpMAVArr;
    
}


- (MAV*) getMAVForUpdateWithSystemID:(uint8_t)systemID CompID:(uint8_t)componentID {
    NSArray *mavArr = _mavArray;
    
    for (MAV *objMAV in mavArr) {
        if (objMAV.systemID == systemID && objMAV.componentID == componentID) {
            return objMAV;
        }
    }
    
	uint8_t mavNumber = 0;
	
    
    if ([mavArr count] > 0) {
		mavNumber = [mavArr count];
	} else {
		mavNumber = 0;
	}
	
    MAV *newMAV = [[MAV alloc] initValues];
    newMAV.mavNumber = mavNumber;
    newMAV.systemID = systemID;
    newMAV.componentID = componentID;
    return newMAV;
}



@end

