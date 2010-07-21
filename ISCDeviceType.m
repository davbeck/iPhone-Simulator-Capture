//
//  ISCDeviceType.m
//  iPhone Simulator Capture
//
//  Created by David Beck on 7/8/10.
//  Copyright 2010 David Beck. All rights reserved.
//

#import "ISCDeviceType.h"


@implementation ISCDeviceType

@synthesize screenRect=_screenRect;
@synthesize frameLocation=_frameLocation;

@synthesize videoSize=_videoSize;

@synthesize frameImage=_frameImage;


+ (ISCDeviceType *)iphone
{
	static ISCDeviceType *iphone;
	@synchronized (self) {
		if (iphone == nil) {
			iphone = [[ISCDeviceType alloc] init];
		}
	}
	return iphone;
}

+ (ISCDeviceType *)ipad
{
	static ISCDeviceType *ipad;
	@synchronized (self) {
		if (ipad == nil) {
			ipad = [[ISCDeviceType alloc] init];
		}
	}
	return ipad;
}

+ (ISCDeviceType *)iphoneHD
{
	static ISCDeviceType *iphoneHD;
	@synchronized (self) {
		if (iphoneHD == nil) {
			iphoneHD = [[ISCDeviceType alloc] init];
		}
	}
	return iphoneHD;
}

- (id)initWithScreenRect:(CGRect)screenRect frameLocation:(CGPoint)frameLocation videoSize:(CGSize)videoSize frameImage:(NSImage *)frameImage
{
	if (self = [super init]) {
		_screenRect = screenRect;
		_frameLocation = frameLocation;
		_videoSize = videoSize;
		_frameImage = [frameImage retain];
	}
	return self;
}

- (id)retain
{
	return self;
}

- (NSUInteger)retainCount
{
	return NSUIntegerMax;
}

- (void)release
{
}

- (id)autorelease
{
	return self;
}

@end
