//
//  ISCFrame.m
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

#import "ISCFrame.h"

#import "ImageRect.h"

const NSPoint ISCScreenLocationWithOverlay = {.x = (CGFloat)28.0, .y = (CGFloat)218.0};
const NSPoint ISCOverlayLoacaionWithPointer = {.x = (CGFloat)187.0, .y = (CGFloat)76.0};
const NSPoint ISCScreenLocationWithPointer = {.x = (CGFloat)215.0, .y = (CGFloat)294.0};
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
	self = [super init];
	if (self != nil) {
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
	if (withPointer && withOverlay) {
		//even if withFrame was yes we would use this because it is the bigger of the two
		frameSize = ISCFrameWithPointerSize;
		
		screenPoint = ISCScreenLocationWithPointer;
		
		frameLocation = ISCOverlayLoacaionWithPointer;
		
		//get the hover or active image
		mouseImage = [ISCFrame pointerImageForState:isMouseDown];
	} else if (withPointer) {
		//screenPoint = ISCScreenLocationWithPointer;
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
		[[ISCFrame overlay] drawAtPoint:frameLocation fraction:1.0];
	}
	
	//draw the actual screen shot in the center of the screen
	[screenshot drawAtPoint:screenPoint fraction:1.0];
	
	if (withPointer) {
		NSPoint centerLocation = location;
		
		centerLocation.x += screenPoint.x - [mouseImage size].width / 2.0;
		centerLocation.y += screenPoint.y - [mouseImage size].height / 2.0;
		
		//NSLog(@"pointer: %@", NSStringFromPoint(centerLocation));
		
		//draw the pointer ofset to center
		[mouseImage drawAtPoint:centerLocation fraction:0.8];
	}
	
	[frameImage unlockFocus];
	
	return [frameImage autorelease];
}

@end
