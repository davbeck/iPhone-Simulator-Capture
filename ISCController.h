//
//  ISCController.h
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
@class ISCFrame;
@class ISCRecording;

//the number of seconds in a minute
#define kSecondsInMinute 60

#define kISCPanelProgressHeight 75.0
#define kISCPanelRecordHeight 103.0


@interface ISCController : NSObject {
	ISCRecording *recording;
	
	//the menu that gets added to the app menu
	IBOutlet NSMenuItem *menu;
	//the label that shows how long the video is
	IBOutlet NSTextField *lengthLabel;
	//the progress indicator that shows the progress of the rendering
	IBOutlet NSProgressIndicator *indicator;
	//the window that has the record button. resize it when we save
	IBOutlet NSButton *recordButton;
	
	NSURL *saveURL;
}

@property (nonatomic, retain) IBOutlet NSMenuItem *menu;
@property (nonatomic, retain) IBOutlet NSTextField *lengthLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *indicator;
@property (nonatomic, retain) IBOutlet NSButton *recordButton;

#pragma mark -
#pragma mark Initialization
+ (void)load;
+ (ISCController *)sharedInstance;

#pragma mark -
#pragma mark Actions
- (IBAction)startStopRecording:(id)sender;
- (IBAction)saveMovie:(id)sender;
- (void)writeMovie:(QTMovie *)movie toURL:(NSURL *)url;
- (NSURL *)getFileName;

- (void)showProgressBar:(BOOL)show;

@end
