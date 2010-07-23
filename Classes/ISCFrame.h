//
//  ISCFrame.h
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
