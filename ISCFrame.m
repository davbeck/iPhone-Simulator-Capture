//
//  ISCFrame.m
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/16/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import "ISCFrame.h"

#import "ImageRect.h"

const NSPoint ISCScreenLocationWithOverlay = {.x = (CGFloat)28.0, .y = (CGFloat)218.0};
const NSPoint ISCOverlayLoacaionWithPointer = {.x = (CGFloat)122.0, .y = (CGFloat)76.0};
const NSPoint ISCScreenLocationWithPointer = {.x = (CGFloat)158.0, .y = (CGFloat)309.0};
const NSSize ISCFrameWithPointerSize = {.width = (CGFloat)750.0, .height = (CGFloat)1000.0};


@implementation ISCFrame

@synthesize screenshot;
@synthesize isMouseDown;
@synthesize location;

- (void)dealloc
{
	[screenshot release];
	
	[super dealloc];
}

+ (NSImage *)hoverImage
{
	static NSImage *hoverImage = nil;
	if (hoverImage == nil) {
		//get the url for the hover image from our bundle (not main bundle)
		NSURL *hoverURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Hover" withExtension:@"png"];
		
		hoverImage = [[NSImage alloc] initWithContentsOfURL:hoverURL];
	}
	return hoverImage;
}
+ (NSImage *)activeImage
{
	static NSImage *activeImage = nil;
	if (activeImage == nil) {
		//get the url for the hover image from our bundle (not main bundle)
		NSURL *activeURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Active" withExtension:@"png"];
		
		activeImage = [[NSImage alloc] initWithContentsOfURL:activeURL];
	}
	return activeImage;
}
+ (NSImage *)overlay
{
	static NSImage *overlay = nil;
	if (overlay == nil) {
		//get the url for the hover image from our bundle (not main bundle)
		NSURL *overlayURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"Overlay" withExtension:@"png"];
		
		overlay = [[NSImage alloc] initWithContentsOfURL:overlayURL];
	}
	return overlay;
}
+ (NSImage *)pointerImageForState:(BOOL)state
{
	if (state) {
		return [ISCFrame activeImage];
	} else {
		return [ISCFrame hoverImage];
	}
}


- (id)initWithScreenshot:(NSImage *)iScreenshot
			 isMouseDown:(BOOL)iIsMouseDown
				location:(NSPoint)iLocation
			 orientation:(enum ISCFrameOrientation)orientation
{
	if (self = [super init]) {
		screenshot = iScreenshot;
		[screenshot retain];
		[screenshot setCacheMode:NSImageCacheNever];
		
		isMouseDown = iIsMouseDown;
		
		location = iLocation;
		if (orientation == ISCFrameOrientationLandscapeLeft) {
			location.x = iLocation.y;
			location.y = [screenshot size].height - iLocation.x;
		} else if (orientation == ISCFrameOrientationLandscapeRight) {
			location.x = [screenshot size].width - iLocation.y;
			location.y = iLocation.x;
		}
	}
	return self;
}


- (NSImage *)renderedImageWithPointer:(BOOL)withPointer overlay:(BOOL)withOverlay background:(NSColor *)backgroundColor
{
	NSSize frameSize = [screenshot size];
	NSPoint screenPoint = NSZeroPoint;
	NSPoint frameLocation = NSZeroPoint;
	NSImage *mouseImage;
	
	//check largest to smalles size
	if (withPointer) {
		//even if withFrame was yes we would use this because it is the bigger of the two
		frameSize = ISCFrameWithPointerSize;
		
		screenPoint = ISCScreenLocationWithPointer;
		
		frameLocation = ISCOverlayLoacaionWithPointer;
		
		//get the hover or active image
		mouseImage = [ISCFrame pointerImageForState:isMouseDown];
	} else if (withOverlay) {
		frameSize = [[ISCFrame overlay] size];
		
		screenPoint = ISCScreenLocationWithOverlay;
		
		frameLocation = NSZeroPoint;
	}
	
	//the image that we are going to draw everything into
	NSImage *frameImage = [[NSImage alloc] initWithSize:frameSize];
	
	[frameImage lockFocus];
	
	[backgroundColor set];
	[NSBezierPath fillRect:[frameImage bounds]];
	
	if (withOverlay) {
		//draw the iPhone frame on top (glare needs to be on top)
		[[ISCFrame overlay] drawAtPoint:frameLocation
						   fraction:1.0];
	}
	
	//draw the actual screen shot in the center of the screen
	[screenshot drawAtPoint:screenPoint
				fraction:1.0];
	
	if (withPointer) {
		NSPoint centerLocation = location;
		
		centerLocation.x += screenPoint.x - [mouseImage size].width / 2.0;
		centerLocation.y += screenPoint.y - [mouseImage size].height / 2.0;
		
		
		//draw the pointer ofset to center
		[mouseImage drawAtPoint:centerLocation
					   fraction:0.8];
	}
	
	[frameImage unlockFocus];
	
	return [frameImage autorelease];
}

@end
