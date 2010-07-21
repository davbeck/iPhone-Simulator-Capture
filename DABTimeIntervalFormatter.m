//
//  DABTimeIntervalFormatter.m
//
//  Created by David Beck on 10/19/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import "DABTimeIntervalFormatter.h"


@implementation DABTimeIntervalFormatter


- (NSString *)stringForObjectValue:(NSNumber *)obj
{
	//we don't care about microseconds
	int timeInterval = [obj intValue];
	
	NSString *formattedString = [NSString stringWithFormat:@"%d:%02d", 
								 timeInterval / kSecondsInMinute, 
								 timeInterval % kSecondsInMinute];
	
	return formattedString;
}

@end
