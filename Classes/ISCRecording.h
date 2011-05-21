//
//  ISCRecording.h
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
	
	//the timer that fires every kFrameRate to record the frame
	NSTimer *captureTimer;
	
	//the time when we start recording. used to calculate time since
	NSDate *startTime;
	NSTimeInterval _length;
	
	QTMovie *_movie;
	
	NSOperationQueue *_renderQueue;
	
	NSColor *_backgroundColor;
	BOOL _withPointer;
	BOOL _withFrame;
	
	double _lastProgress;
}
@property (assign) id delegate;

@property (readonly) NSTimeInterval length;
@property BOOL isRecording;
@property (readonly) QTMovie *movie;
@property (nonatomic, readonly) NSColor *backgroundColor;

- (id)initWithDelegate:(id)iDelegate;

- (void)start;
- (void)stop;

- (void)recordFrame;

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
