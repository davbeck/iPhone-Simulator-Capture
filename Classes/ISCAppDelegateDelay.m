//
//  AppDelegateDelay.m
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
	self = [super init];
	if (self != nil) {
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
