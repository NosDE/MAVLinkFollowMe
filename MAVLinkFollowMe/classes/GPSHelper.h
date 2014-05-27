@interface GPSHelper : NSObject

- (double)getDirectionfromSrcLat:(double)srcLat srcLon:(double)srcLon dstLat:(double)dstLat dstLon:(double)dstLon;
- (NSInteger)getRotateDirectionFromMyHdg:(NSInteger)myhdg toTargetHdg:(NSInteger)targethdg;

@end
