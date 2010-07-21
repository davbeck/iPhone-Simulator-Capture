//
//  AppDelegateDelay.m
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/16/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import "ISCAppDelegateDelay.h"
#import "SynthesizeSingleton.h"


@implementation ISCAppDelegateDelay

@synthesize secondDelegate;

@synthesize shouldTerminate;

- (void)setShouldTerminate:(BOOL)nShouldTerminate
{
	shouldTerminate = nShouldTerminate;
	
	if (delayedTermination && shouldTerminate) {
		if ([secondDelegate applicationShouldTerminate:NSApp] != NSTerminateLater) {
			[NSApp replyToApplicationShouldTerminate:[secondDelegate applicationShouldTerminate:NSApp]];
		}
	}
}


//return singleton instance
SYNTHESIZE_SINGLETON_FOR_CLASS(ISCAppDelegateDelay)

- (id)init
{
	if (self = [super init]) {
		delayedTermination = NO;
		shouldTerminate = YES;
		
		secondDelegate = [NSApp delegate];
		
		[NSApp setDelegate:self];
	}
	return self;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	if (shouldTerminate) {
		return [secondDelegate applicationShouldTerminate:sender];
	} else {
		delayedTermination = YES;
		
		return NSTerminateLater;
	}
}


//swizzle to the original app delegate
- (BOOL)respondsToSelector:(SEL)aSelector
{
	return [super respondsToSelector:aSelector] || [secondDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
	return secondDelegate;
}


@end
