//
//  CaptureController.m
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/13/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import "ISCController.h"
#import "SynthesizeSingleton.h"

#import "iPhone Simulator.h"

#import <QTKit/QTKit.h>

#import "QTMovieExtensions.h"
#import "ImageRect.h"
#import "ISCFrame.h"
#import "ISCRecording.h"
#import "ISCAppDelegateDelay.h"

@implementation ISCController

@synthesize menu, lengthLabel, indicator, recordButton;


#pragma mark -
#pragma mark Memory Management
- (void)dealloc
{
	self.menu = nil;
	self.lengthLabel = nil;
	self.indicator = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Initialization
- (id)init
{
	if (self = [super init]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
									 @"NO", @"ISCRecordWindowVisible",
									 nil];
		
		[defaults registerDefaults:appDefaults];
		
		//load in our menu and window
		[NSBundle loadNibNamed:@"PluginController" owner:self];
		
		//add our menu to the application menu
		//place it right before teh window and help menu
		[[NSApp mainMenu] insertItem:menu atIndex:[[NSApp mainMenu] numberOfItems] - 2];
		
		[lengthLabel setDoubleValue:[recording length]];
		
		
		ProcessControl *processControl = [[NSApp delegate] valueForKey:@"_simulatedProcess"];
		
		NSLog(@"process: %@", [processControl applicationSupportDirectory]);
		
		//NSLog(@"homeDirectory: %@", [[ProcessControl sharedInstance] simulatedHomeDirectory]);
	}
	return self;
}

//A special method called by SIMBL once the application has started and all classes are initialized.
+ (void)load
{
	//force creation of shared object
	[ISCController sharedInstance];
}

//return the single static instance of the plugin object
SYNTHESIZE_SINGLETON_FOR_CLASS(ISCController)


#pragma mark -
#pragma mark ISCRecording Delegate Methods
- (void)ISCRecording:(ISCRecording *)rec renderingProgress:(double)progress
{
	[indicator setDoubleValue:progress];
}

- (void)ISCRecordingDidFinishRendering:(ISCRecording *)rec
{
	[self writeMovie:[rec movie] toURL:saveURL];
	[saveURL release];
	saveURL = nil;
	
	[self showProgressBar:NO];
}

- (void)ISCRecordingLengthChanged:(ISCRecording *)rec
{
	[lengthLabel setDoubleValue:[rec length]];
}


#pragma mark -
#pragma mark Actions

//either start or stops the recording based on the new state of the sender
- (IBAction)startStopRecording:(id)sender
{
	if ([sender state] == NSOnState) {
		[recording release];
		recording = [[ISCRecording alloc] initWithDelegate:self];
		[recording start];
	} else {
		[recording stop];
	}
}

//stops recording if still recording
//saves composites image data into video and saves it
- (IBAction)saveMovie:(id)sender
{
	[recording stop];
	
	//get the filename from the user
	NSURL *filename = [self getFileName];
	
	//nil means they canceled save
	if(filename != nil) {
		if ([recording movie] == nil) {
			[self showProgressBar:YES];
			
			[recording generateMovie];
			
			saveURL = filename;
			[saveURL retain];
		} else {
			[self writeMovie:[recording movie] toURL:filename];
		}
	}
}

- (void)writeMovie:(QTMovie *)movie toURL:(NSURL *)url
{
	[movie writeToFile:[url path] 
	    withAttributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] 
										  forKey:QTMovieFlatten] 
			   error:nil];
}

//ask the user for a filename
//returns nil if the user cancels
- (NSURL *)getFileName
{
	NSSavePanel *savePanel;
	
	savePanel = [NSSavePanel savePanel];
	[savePanel setExtensionHidden:YES];
	[savePanel setCanSelectHiddenExtension:NO];
	[savePanel setTreatsFilePackagesAsDirectories:NO];
	
	//if the user doesn't cancel the save, return the filename they selected
	if ([savePanel runModal] == NSOKButton) {
		return [savePanel URL];
	}
	//return nil if the user canceled the save
	return nil;
}

- (void)showProgressBar:(BOOL)show
{
	if (show) {
		[indicator setDoubleValue:0.0];
		[[indicator window] makeKeyAndOrderFront:self];
	}
	
	NSRect frame = [[indicator window] frame];
	
	CGFloat newHeight;
	if (show) {
		newHeight = kISCPanelProgressHeight;
	} else {
		newHeight = kISCPanelRecordHeight;
	}
	
	frame.origin.y += frame.size.height - newHeight;
	frame.size.height = newHeight;
	
	[NSAnimationContext beginGrouping];
	
	[[indicator animator] setHidden:!show];
	
	[[recordButton animator] setHidden:show];
	[[lengthLabel animator] setHidden:show];
	
	[[[indicator window] animator] setFrame:frame 
						 display:YES];
	
	[NSAnimationContext endGrouping];
}

@end
