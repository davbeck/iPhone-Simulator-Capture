//
//  ISCRecording.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/19/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class QTMovie;

//the frames in a second to record and render the movie
#define kFramesPerSecond 20.0
//the length of time, in seconds, for a frame
#define kFrameRate 1.0/kFramesPerSecond
//the value from [NSEvent pressedMouseButtons] when the left mouse button is down
#define kLeftMouseDown 1 << 0

//preference keys
extern NSString *ISCRecordPointerKey;
extern NSString *ISCShowFrameKey;
extern NSString *ISCBackgroundColorKey;

@interface ISCRecording : NSObject {
	id delegate;
	
	//an array of ISCFrame objects that are added to while recording
	NSMutableArray *frames;
	//the timer that fires every kFrameRate to record the frame
	NSTimer *captureTimer;
	
	//the time when we start recording. used to calculate time since
	NSDate *startTime;
	NSTimeInterval length;
	
	QTMovie *movie;
}
@property (assign) id delegate;

@property (readonly) NSTimeInterval length;
@property BOOL isRecording;
@property (readonly) QTMovie *movie;

- (id)initWithDelegate:(id)iDelegate;

- (void)start;
- (void)stop;

- (void)recordFrame;

- (void)generateMovie;
- (void)render;
- (void)addFrameToMovie:(NSImage *)image withColor:(NSColor *)color;

@end


//delegate declaration
@interface NSObject (ISCRecordingDelegate)
//optional methods
- (void)ISCRecording:(ISCRecording *)recording renderingProgress:(double)progress;
- (void)ISCRecordingDidFinishRendering:(ISCRecording *)recording;
- (void)ISCRecordingLengthChanged:(ISCRecording *)recording;

//required methods
@end
