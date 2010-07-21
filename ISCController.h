//
//  ISCController.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/13/09.
//  Copyright 2009 David Beck. All rights reserved.
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
