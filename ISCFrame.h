//
//  ISCFrame.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/16/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//rendering positions
extern const NSPoint ISCScreenLocationWithOverlay;
extern const NSPoint ISCOverlayLoacaionWithPointer;
extern const NSPoint ISCScreenLocationWithPointer;
extern const NSSize ISCFrameWithPointerSize;

enum ISCFrameOrientation {
	ISCFrameOrientationPortrait=1,
	ISCFrameOrientationLandscapeLeft=3,
	ISCFrameOrientationLandscapeRight=4
};


@interface ISCFrame : NSObject {
	NSImage *screenshot;
	
	BOOL isMouseDown;
	NSPoint location;
}

//we are using a threaded applicationa and 
//this object is used extensivly in multiple threads

@property (retain, readonly) NSImage *screenshot;

@property (readonly) BOOL isMouseDown;
@property (readonly) NSPoint location;

+ (NSImage *)hoverImage;
+ (NSImage *)activeImage;
+ (NSImage *)overlay;
+ (NSImage *)pointerImageForState:(BOOL)state;

- (id)initWithScreenshot:(NSImage *)iScreenshot
			 isMouseDown:(BOOL)iIsMouseDown
				location:(NSPoint)iLocation
			 orientation:(enum ISCFrameOrientation)iOrientation;

- (NSImage *)renderedImageWithPointer:(BOOL)withPointer overlay:(BOOL)withOverlay background:(NSColor *)backgroundColor;

@end
