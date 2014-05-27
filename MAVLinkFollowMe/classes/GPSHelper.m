#import <Foundation/Foundation.h>
#import <math.h>
#import "GPSHelper.h"

 
@implementation GPSHelper

- (double)getDirectionfromSrcLat:(double)srcLat srcLon:(double)srcLon dstLat:(double)dstLat dstLon:(double)dstLon
{
	NSInteger direction = 0;
	double dLon = 0;
	double x = 0;
	double y = 0;
	
	srcLat = (srcLat * M_PI) / 180;
	dstLat = (dstLat * M_PI) / 180;
	dLon = ((dstLon - srcLon) * M_PI) / 180;
	
	y = sin(dLon) * cos(dstLat);
	x = cos(srcLat) * sin(dstLat) - sin(srcLat) * cos(dstLat) * cos(dLon);
	
	direction = (NSInteger)(((atan2(y, x) * 180) / M_PI) + 360) % 360;
	
	return direction;
}

- (NSInteger)getRotateDirectionFromMyHdg:(NSInteger)myhdg toTargetHdg:(NSInteger)targethdg
{
	NSInteger direction = 1;
	if ((targethdg - myhdg) > 180 || ((targethdg - myhdg) < 0 && (targethdg - myhdg) > -181)) {
		direction = -1;
	}

	return direction;
}

@end

