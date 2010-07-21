//
//  ISCDeviceType.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 7/8/10.
//  Copyright 2010 David Beck. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ISCDeviceType : NSObject {
	CGRect _screenRect;
	CGPoint _frameLocation;
	
	CGSize _videoSize;
	
	NSImage *_frameImage;
}

@property (nonatomic, readonly) CGRect screenRect;
@property (nonatomic, readonly) CGPoint frameLocation;

@property (nonatomic, readonly) CGSize videoSize;

@property (nonatomic, readonly) NSImage *frameImage;

+ (ISCDeviceType *)iphone;
+ (ISCDeviceType *)ipad;
+ (ISCDeviceType *)iphoneHD;

- (id)initWithScreenRect:(CGRect)screenRect frameLocation:(CGPoint)frameLocation videoSize:(CGSize)videoSize frameImage:(NSImage *)frameImage;

@end
