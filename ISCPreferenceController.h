//
//  ISCPreferenceController.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/17/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kRowsOnPage 4
#define kAppsOnRow 4

extern NSString *ISCIconStatePrefPath;

//used to set preferences for SpringBoard
extern NSString *ISCSBFakeTimeKey;
extern NSString *ISCSBFakeTimeStringKey;
extern NSString *ISCSBFakeCarrierKey;

extern NSSize ISCPreferencesSizeWithRestart;

#define kISCPreferencesNibName @"Preferences"

@interface ISCPreferenceController : NSWindowController {
	IBOutlet NSTextField *fakeTimeField;
	IBOutlet NSView *restartMessage;
}

@property (retain) IBOutlet NSTextField *fakeTimeField;
@property (retain) IBOutlet NSView *restartMessage;

//backed by springboard preferences
@property BOOL shouldUseFakeTime;
@property (retain) NSString *fakeTime;
@property (retain) NSString *fakeCarrier;

- (NSString *)springboardPreferencePath;
- (NSString *)currentVersion;
- (NSDictionary *)iconState;
- (NSDictionary *)iconState;
- (void)saveIconState:(NSDictionary *)iconState;

- (IBAction)installFakeApps:(id)sender;
- (IBAction)arrangeFakeApps:(id)sender;
- (IBAction)restart:(id)sender;

- (void)showRestartNotice;

@end
