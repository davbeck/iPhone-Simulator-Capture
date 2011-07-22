//
//  ISCDeviceType.m
//  iPhone Simulator Capture
//
//  Copyright (c) 2010, David Beck
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without modification, 
//  are permitted provided that the following conditions are met:
//  
//  - Redistributions of source code must retain the above copyright notice, 
//    this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice, 
//    this list of conditions and the following disclaimer in the documentation 
//    and/or other materials provided with the distribution.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
//  OF THE POSSIBILITY OF SUCH DAMAGE.
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
	self = [super init];
	if (self != nil) {
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

- (oneway void)release
{
}

- (id)autorelease
{
	return self;
}

@end
