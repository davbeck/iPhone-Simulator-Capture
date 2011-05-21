//
//  ISCRecording.m
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

#import "ISCRecording.h"

#import <QTKit/QTKit.h>
#import <objc/Object.h>

#import "ISCFrame.h"
#import "ISCAppDelegateDelay.h"

#import "iPhone Simulator.h"

NSString *ISCRecordPointerKey = @"ISCRecordPointer";
NSString *ISCShowFrameKey = @"ISCShowFrame";
NSString *ISCBackgroundColorKey = @"ISCBackgroundColor";


@interface ISCRecording ()

- (void)_didFinsihRendering;

@end


@implementation ISCRecording

@synthesize delegate;
@synthesize length=_length;
@synthesize movie=_movie;

- (void)dealloc
{
	[_movie release];
	[startTime release];
	[_backgroundColor release];
	
	[captureTimer invalidate];
	
	[super dealloc];
}


#pragma mark -
#pragma mark Initialization
- (id)initWithDelegate:(id)iDelegate
{
	self = [super init];
	if (self != nil) {
		delegate = iDelegate;
		
		_renderQueue = [[NSOperationQueue alloc] init];
		_renderQueue.maxConcurrentOperationCount = 1;
	}
	return self;
}


#pragma mark -
#pragma mark Accessors
//length
- (NSTimeInterval)length
{
	if (startTime == nil) {
		return _length;
	}
	
	return [[NSDate date] timeIntervalSinceDate:startTime];
}

//recording
- (BOOL)isRecording
{
	return captureTimer != nil;
}

- (void)setIsRecording:(BOOL)nIsRecording
{
	if (nIsRecording && captureTimer == nil) {
		[self start];
	} else if (!nIsRecording && captureTimer != nil) {
		[self stop];
	}
}

//movie
- (QTMovie *)movie
{
	//only return the movie if it is finished rendering
	if ([_renderQueue operationCount] > 1) {//the last operation is the finished operation
		return nil;
	}
	return _movie;
}

- (NSColor *)backgroundColor
{
	NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISCBackgroundColor"];
	NSColor *backgroundColor = nil;
	if ([colorData length] > 0) {
		backgroundColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
	} else {
		backgroundColor = [NSColor blackColor];
	}
	return backgroundColor;
}


#pragma mark -
#pragma mark Recording Commands
- (void)start
{
	startTime = [[NSDate alloc] init];
	
	_withPointer = [[[NSUserDefaults standardUserDefaults] objectForKey:ISCRecordPointerKey] boolValue];
	_withFrame = [[[NSUserDefaults standardUserDefaults] objectForKey:ISCShowFrameKey] boolValue];
	_backgroundColor = [[self backgroundColor] retain];
	
	_movie = [[QTMovie alloc] initToWritableData:[NSMutableData data] error:nil];
	[_movie setAttribute:[NSNumber numberWithLong:20] forKey:QTMovieTimeScaleAttribute];
	[_movie detachFromCurrentThread];
	
	[_renderQueue cancelAllOperations];
	
	//capture the view/cursor every frame
	captureTimer = [NSTimer timerWithTimeInterval:kFrameRate target:self selector:@selector(recordFrame) userInfo:nil repeats:YES];
	// This should allow the time to continue to update, even when I've chosen a menu item:
	[[NSRunLoop currentRunLoop] addTimer:captureTimer forMode:NSRunLoopCommonModes];
}

- (void)stop
{
	if (captureTimer != nil) {
		//stop captureing frames
		[captureTimer invalidate];
		captureTimer = nil;
		
		_length = [[NSDate date] timeIntervalSinceDate:startTime];
		//free starting time
		[startTime release];
		startTime = nil;
		
		[_renderQueue addOperationWithBlock:^{
			[self _didFinsihRendering];
			NSLog(@"movie: %@", _movie);
		}];
	}
}


#pragma mark -
#pragma mark Recording

- (void)recordFrame
{
	//the window of the simulator
	NSWindow *simulatorWindow = [[NSApp windows] objectAtIndex:0];
	//the view that shows the simulated screenshot
	//SimulatorView *simulatorView = [[[simulatorWindow contentView] subviews] objectAtIndex:1];
	SimulatorView *simulatorView = [[NSApp delegate] simulatorView];
	
	MonitorViewController *monitorViewController = nil;
	object_getInstanceVariable(simulatorView, "_monitorViewController", (void **)&monitorViewController);
	
	//get the mouse location from the window and convert it to the views cordinate system
	NSPoint locationInView = [simulatorView convertPoint:[simulatorWindow mouseLocationOutsideOfEventStream] fromView:nil];
	
	NSImage *screenshot = [[NSImage alloc] initWithData:[[monitorViewController bitmapImageRep] TIFFRepresentation]];
	
	ISCFrame *frame = [[ISCFrame alloc] initWithScreenshot:screenshot
											   isMouseDown:[NSEvent pressedMouseButtons] ==  kLeftMouseDown 
												  location:locationInView 
											   orientation:[(MonitorController *)[NSApp delegate] orientation]];
	
	[_renderQueue addOperationWithBlock:^{
		[_movie attachToCurrentThread];
		
		NSImage *frameImage = [frame renderedImageWithPointer:_withPointer overlay:_withFrame background:_backgroundColor];
		[self addFrameToMovie:frameImage withColor:[self backgroundColor]];
		
		[self performSelectorOnMainThread:@selector(updateRenderingProgress) withObject:nil waitUntilDone:NO];
		
		[_movie detachFromCurrentThread];
	}];
	
	[frame release];
	[screenshot release];
	
	if ([delegate respondsToSelector:@selector(ISCRecordingLengthChanged:)]) {
		[delegate ISCRecordingLengthChanged:self];
	}
}

- (void)addFrameToMovie:(NSImage *)image withColor:(NSColor *)color
{
	QTTime time = QTMakeTime(1, kFramesPerSecond);
	NSDictionary *attrs;
	if ([color alphaComponent] < 1.0) {
		//by using png, the video will have transparency
		attrs = [[NSDictionary alloc] initWithObjectsAndKeys:
				 @"png ", QTAddImageCodecType,
				 [NSNumber numberWithLong:codecHighQuality], QTAddImageCodecQuality,
				 nil];
	} else {
		//mp4v is much faster
		attrs = [[NSDictionary alloc] initWithObjectsAndKeys:
				 @"mp4v", QTAddImageCodecType,
				 [NSNumber numberWithLong:codecHighQuality], QTAddImageCodecQuality,
				 nil];
	}
	
	[_movie addImage:image forDuration:time withAttributes:attrs];
	[attrs release];
}

#pragma mark - Delegate Messages

- (void)updateRenderingProgress
{
	//minus 1 for the current operation and minus 1 for the finished operation
	double progress = (double)[_movie duration].timeValue / (double)([_movie duration].timeValue + [_renderQueue operationCount] - 2);
	if (progress - _lastProgress > 0.005) {
		_lastProgress = progress;
		
		if ([delegate respondsToSelector:@selector(ISCRecording:renderingProgress:)]) {
			[delegate ISCRecording:self renderingProgress:progress];
		}
		
		NSLog(@"progress: %f", progress * 100.0);
	}
}

- (void)_didFinsihRendering
{
	NSLog(@"didFinsihRendering");
	if ([delegate respondsToSelector:@selector(ISCRecordingDidFinishRendering:)]) {
		[delegate performSelectorOnMainThread:@selector(ISCRecordingDidFinishRendering:) withObject:self waitUntilDone:YES];
	}
}

@end
