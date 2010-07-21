//
//  ISCAppDelegateDelay.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/16/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ISCAppDelegateDelay : NSObject <NSApplicationDelegate> {
	id secondDelegate;
	
	BOOL shouldTerminate;
	
	BOOL delayedTermination;
}

@property (nonatomic, readonly) id secondDelegate;

@property (nonatomic) BOOL shouldTerminate;

+ (ISCAppDelegateDelay *)sharedInstance;

@end
