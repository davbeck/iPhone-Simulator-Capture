//
//  ISCPreferenceController.m
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

#import "ISCPreferenceController.h"

#import "iPhone Simulator.h"
#import "ISCArraySections.h"
#import "ISCRecording.h"

NSString *ISCIconStatePrefPath = @"~/Library/Application Support/iPhone Simulator/Library/SpringBoard/IconState.plist";

NSString *ISCSBFakeTimeKey = @"SBFakeTime";
NSString *ISCSBFakeTimeStringKey = @"SBFakeTimeString";
NSString *ISCSBFakeCarrierKey = @"SBFakeCarrier";

NSSize ISCPreferencesSizeWithRestart = {.width=(CGFloat)470.0, .height=(CGFloat)258.0};

@implementation ISCPreferenceController

@synthesize fakeTimeField;
@synthesize restartMessage;

- (id)init
{
	if (self= [super initWithWindowNibName:kISCPreferencesNibName]) {
		[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	}
	return self;
}

- (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	NSData *backgroundData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor blackColor]];
	
	[defaultValues setObject:backgroundData forKey:ISCBackgroundColorKey];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

//expand the constant at runtime to the users preference path
- (NSString *)springboardPreferencePath
{
	NSString *userPreferencePath = [[[NSApp delegate] valueForKey:@"_simulatedProcess"] simulatedHomeDirectory];
	userPreferencePath = [userPreferencePath stringByAppendingString:@"/Library/Preferences/com.apple.springboard.plist"];
	return userPreferencePath;
}

- (NSString *)currentVersion
{
	NSString *userPreferencePath = [[[NSApp delegate] valueForKey:@"_simulatedProcess"] simulatedHomeDirectory];
	return [userPreferencePath lastPathComponent];
}

- (NSDictionary *)iconState
{
	NSString *userPreferencePath = [self springboardPreferencePath];
	if (![[self currentVersion] isEqual:@"4.0"]) {
		NSDictionary *springboardPreferences = [[[NSMutableDictionary alloc] initWithContentsOfFile:userPreferencePath] autorelease];
		if ([springboardPreferences objectForKey:@"iconState2"] != nil) {
			return [springboardPreferences objectForKey:@"iconState2"];//3.1.3 and below
		} else {
			return [springboardPreferences objectForKey:@"iconState"];//3.2
		}
	} else {
		NSString *iconStatePath = [[[NSApp delegate] valueForKey:@"_simulatedProcess"] simulatedHomeDirectory];
		iconStatePath = [iconStatePath stringByAppendingString:@"/Library/SpringBoard/IconState.plist"];
		NSDictionary *springboardPreferences = [[[NSMutableDictionary alloc] initWithContentsOfFile:iconStatePath] autorelease];
		return springboardPreferences;
	}
}

- (void)saveIconState:(NSDictionary *)iconState
{
	NSString *userPreferencePath = [self springboardPreferencePath];
	if (![[self currentVersion] isEqual:@"4.0"]) {
		NSMutableDictionary *springboardPreferences = [[[NSMutableDictionary alloc] initWithContentsOfFile:userPreferencePath] autorelease];
		if ([springboardPreferences objectForKey:@"iconState2"] != nil) {
			[springboardPreferences setObject:iconState forKey:@"iconState2"];
		} else {
			[springboardPreferences setObject:iconState forKey:@"iconState"];
		}
		[springboardPreferences writeToFile:userPreferencePath atomically:YES];
	} else {
		NSString *iconStatePath = [[[NSApp delegate] valueForKey:@"_simulatedProcess"] simulatedHomeDirectory];
		iconStatePath = [iconStatePath stringByAppendingString:@"/Library/SpringBoard/IconState.plist"];
		[iconState writeToFile:iconStatePath atomically:YES];
	}
	
	[self showRestartNotice];
}

//return the dictionary of preferences for SpringBoard
- (NSMutableDictionary *)springboardPrefs
{
	NSString *userPreferencePath = [self springboardPreferencePath];
	//get the preferences using the path if this is the first time we need them
	return [NSDictionary dictionaryWithContentsOfFile:userPreferencePath];
}

//write the preference dictionary back to file
- (void)saveSpringboardPrefs:(NSDictionary *)springboardPrefs
{
	[springboardPrefs writeToFile:[self springboardPreferencePath] atomically:YES];
	
	[self showRestartNotice];
}

- (BOOL)shouldUseFakeTime
{
	return [[[self springboardPrefs] valueForKey:ISCSBFakeTimeKey] boolValue];
}

- (void)setShouldUseFakeTime:(BOOL)shouldUse
{
	NSMutableDictionary *springboardPrefs = [[self springboardPrefs] mutableCopy];
	[springboardPrefs setObject:[NSNumber numberWithBool:shouldUse] forKey:ISCSBFakeTimeKey];
	[self saveSpringboardPrefs:springboardPrefs];
	
	if (shouldUse) {
		//update here because binding may not have propogated
		[fakeTimeField setEnabled:YES];
		[[fakeTimeField window] makeFirstResponder:fakeTimeField];
	}
}

- (NSString *)fakeTime
{
	return [[self springboardPrefs] valueForKey:ISCSBFakeTimeStringKey];
}

- (void)setFakeTime:(NSString *)timeText
{
	NSMutableDictionary *springboardPrefs = [[self springboardPrefs] mutableCopy];
	if (IsEmpty(timeText)) {
		[springboardPrefs removeObjectForKey:ISCSBFakeTimeStringKey];
	} else {
		[springboardPrefs setObject:timeText forKey:ISCSBFakeTimeStringKey];
	}
	[self saveSpringboardPrefs:springboardPrefs];
}

- (NSString *)fakeCarrier
{
	return [[self springboardPrefs] valueForKey:ISCSBFakeCarrierKey];
}

- (void)setFakeCarrier:(NSString *)fakeCarrier
{
	NSMutableDictionary *springboardPrefs = [[self springboardPrefs] mutableCopy];
	if (IsEmpty(fakeCarrier)) {
		[springboardPrefs removeObjectForKey:ISCSBFakeCarrierKey];
	} else {
		[springboardPrefs setObject:fakeCarrier forKey:ISCSBFakeCarrierKey];
	}
	[self saveSpringboardPrefs:springboardPrefs];
}

- (NSArray *)installedApps
{
	NSDictionary *iconState = [self iconState];
	NSArray *installedApps = [NSArray arrayWithArray:[[iconState objectForKey:@"iconLists"] flatten]];
	installedApps = [installedApps arrayByAddingObjectsFromArray:[[iconState objectForKey:@"buttonBar"] flatten]];
	return installedApps;
}

- (IBAction)installFakeApps:(id)sender
{
	ProcessControl *process = [[NSApp delegate] valueForKey:@"_simulatedProcess"];
	
	NSArray *appPaths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@".app" inDirectory:@"FakeApps"];
	
	for (NSString *path in appPaths) {
		[process installApplication:nil withPath:path];
	}
}

- (IBAction)arrangeFakeApps:(id)sender
{
	[self installFakeApps:nil];
	
	//the order of built in apps
	NSMutableArray *buttonBar = [NSMutableArray arrayWithObjects:
								 @"com.fake.Phone",
								 @"com.fake.Mail",
								 @"com.apple.mobilesafari",
								 @"com.fake.iPod",
								 nil];
	
	NSMutableArray *lists = [NSMutableArray arrayWithObjects:
							 @"com.fake.Messages",
							 @"com.fake.Calendar",
							 @"com.apple.mobileslideshow-Photos",
							 @"com.fake.Camera",
							 
							 @"com.fake.YouTube",
							 @"com.fake.Stocks",
							 @"com.fake.Maps",
							 @"com.fake.Weather",
							 
							 @"com.fake.VoiceMemos",
							 @"com.fake.Notes",
							 @"com.fake.Clock",
							 @"com.fake.Calculator",
							 
							 @"com.apple.Preferences",
							 @"com.fake.iTunes",
							 @"com.fake.AppStore",
							 @"com.fake.Compass",
							 
							 @"com.apple.MobileAddressBook",
							 nil];
	
	NSArray *installedApps = [self installedApps];
	for (NSString *app in installedApps) {
		if (![buttonBar containsObject:app] && ![lists containsObject:app]) {
			[lists addObject:app];
		}
	}
	
	NSArray *pages;
	if ([[self currentVersion] isEqual:@"3.2"] || [[self currentVersion] isEqual:@"4.0"]) {
		pages = [lists arrayWithSectionSize:kAppsOnRow * kRowsOnPage];
	} else {
		//arrange them as pages of rows
		pages = [[lists arrayWithSectionSize:kAppsOnRow] arrayWithSectionSize:kRowsOnPage];
		buttonBar = [NSArray arrayWithObject:buttonBar];
	}
	
	NSMutableDictionary *iconState = [[self iconState] mutableCopy];
	[iconState setObject:pages forKey:@"iconLists"];
	[iconState setObject:buttonBar forKey:@"buttonBar"];
	[self saveIconState:iconState];
}

- (IBAction)restart:(id)sender
{
	ProcessControl *process = [[NSApp delegate] valueForKey:@"_simulatedProcess"];
	[process restart];
}

- (void)showRestartNotice
{
	NSRect oldFrame = [[self window] frame];
	NSRect newFrameRect = [[self window] frameRectForContentRect:NSMakeRect(0.0, 0.0, 
															  ISCPreferencesSizeWithRestart.width, 
															  ISCPreferencesSizeWithRestart.height)];
	
	NSRect frame = [[self window] frame];
	frame.size = newFrameRect.size;
	frame.origin.y -= (newFrameRect.size.height - oldFrame.size.height);
	
	[NSAnimationContext beginGrouping];
	
	[[restartMessage animator] setHidden:NO];
	
	[[[self window] animator] setFrame:frame 
									display:YES];
	
	[NSAnimationContext endGrouping];
}

@end
