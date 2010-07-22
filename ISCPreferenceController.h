//
//  ISCPreferenceController.h
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
