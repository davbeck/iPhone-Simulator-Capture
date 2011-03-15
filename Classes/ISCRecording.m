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

@implementation ISCRecording

@synthesize delegate;
@synthesize length;
@synthesize movie;

- (void)dealloc
{
	[movie release];
	[frames release];
	[startTime release];
	
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
	}
	return self;
}


#pragma mark -
#pragma mark Accessors
//length
- (NSTimeInterval)length
{
	if (startTime == nil) {
		return length;
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
	if ([frames count] > 0) {
		return nil;
	}
	return movie;
}


#pragma mark -
#pragma mark Recording Commands
- (void)start
{
	startTime = [[NSDate alloc] init];
	
	frames = [[NSMutableArray alloc] init];
	
	//capture the view/cursor every frame
	captureTimer = [NSTimer timerWithTimeInterval:kFrameRate 
										   target:self 
										 selector:@selector(recordFrame) 
										 userInfo:nil 
										  repeats:YES];
	// This should allow the time to continue to update, even when I've chosen a menu item:
	[[NSRunLoop currentRunLoop] addTimer:captureTimer forMode:NSRunLoopCommonModes];
}

- (void)stop
{
	//stop captureing frames
	[captureTimer invalidate];
	captureTimer = nil;
	
	length = [[NSDate date] timeIntervalSinceDate:startTime];
	//free starting time
	[startTime release];
	startTime = nil;
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
	NSLog(@"screenshot: %@", screenshot);
	
	ISCFrame *frame = [[ISCFrame alloc] initWithScreenshot:screenshot
											   isMouseDown:[NSEvent pressedMouseButtons] ==  kLeftMouseDown 
												  location:locationInView 
											   orientation:[[NSApp delegate] orientation]];
	
	//add all the values of this frame to a dictionary and add that to the array
	[frames addObject:frame];
	
	[frame release];
	[screenshot release];
	
	if ([delegate respondsToSelector:@selector(ISCRecordingLengthChanged:)]) {
		[delegate ISCRecordingLengthChanged:self];
	}
}

#pragma mark -
#pragma mark Rendering

- (void)generateMovie
{
	if (movie == nil) {
		//initialize the movie in the main thread
		movie = [[QTMovie alloc] initToWritableData:[NSMutableData data] error:nil];
		[movie detachFromCurrentThread];
	}
	
	//process on background thread because it takes forever to render
	[self performSelectorInBackground:@selector(render) withObject:nil];
}

- (void)render
{
	//initialize an autoreleasepool since we are in a different thread
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[ISCAppDelegateDelay sharedInstance].shouldTerminate = NO;
	
	//the initial value. makes sure it doesn't change in the middle
	BOOL withPointer = [[[NSUserDefaults standardUserDefaults] objectForKey:ISCRecordPointerKey] boolValue];
	BOOL withFrame = [[[NSUserDefaults standardUserDefaults] objectForKey:ISCShowFrameKey] boolValue];
	
	NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ISCBackgroundColor"];
	NSColor *backgroundColor = nil;
	if ([colorData length] > 0) {
		backgroundColor = (NSColor *)[NSUnarchiver unarchiveObjectWithData:colorData];
	} else {
		backgroundColor = [NSColor blackColor];
	}
	
#ifdef DEBUG_MODE
	NSDate *startRender = [NSDate date];
#endif
	
	NSInteger initialCount = [frames count];
	NSAutoreleasePool *sPool;
	NSImage *frameImage;
	ISCFrame *frame;
	
	[movie attachToCurrentThread];
	
	while ([frames count] > 0) {
		//this is memory intensive so create another pool we can drain every cycle
		sPool = [[NSAutoreleasePool alloc] init];
		
		frame = [frames objectAtIndex:0];
		
		frameImage = [frame renderedImageWithPointer:withPointer overlay:withFrame background:backgroundColor];
		
		//add the generated image to the movie
		[self addFrameToMovie:frameImage withColor:backgroundColor];
		
		[frames removeObjectAtIndex:0];
		
		[self performSelectorOnMainThread:@selector(renderingProgress:)
							   withObject:[NSNumber numberWithDouble:1.0 - (double)[frames count] / (double)initialCount] 
							waitUntilDone:NO];
		
		[sPool drain];
	}
	
	[movie detachFromCurrentThread];
	
#ifdef DEBUG_MODE
	NSLog(@"render/record: %f", [[NSDate date] timeIntervalSinceDate:startRender] / [self length]);
#endif
	
	[self performSelectorOnMainThread:@selector(didFinsihRendering) 
						   withObject:nil 
						waitUntilDone:NO];
	
	[ISCAppDelegateDelay sharedInstance].shouldTerminate = YES;
	
	[pool drain];
}

- (void)addFrameToMovie:(NSImage *)image withColor:(NSColor *)color
{
	QTTime time = QTMakeTime(1, kFramesPerSecond);
	NSDictionary *attrs;
	if ([color alphaComponent] < 1.0) {
		//by using png, the video will have transparency
		attrs = [[NSDictionary alloc] initWithObjectsAndKeys:@"png ", QTAddImageCodecType, nil];
	} else {
		//jpeg is much faster
		attrs = [[NSDictionary alloc] initWithObjectsAndKeys:@"jpeg", QTAddImageCodecType, nil];
	}
	
	
	[movie addImage:image forDuration:time withAttributes:attrs];
	[attrs release];
}

#pragma mark -
#pragma mark Delegate Messages
//we have to use NSNumber to use performSelectorInMainThread:
- (void)renderingProgress:(NSNumber *)progress
{
	if ([delegate respondsToSelector:@selector(ISCRecording:renderingProgress:)]) {
		[delegate ISCRecording:self renderingProgress:[progress doubleValue]];
	}
}

- (void)didFinsihRendering
{
	if ([delegate respondsToSelector:@selector(ISCRecordingDidFinishRendering:)]) {
		[delegate ISCRecordingDidFinishRendering:self];
	}
}

@end
