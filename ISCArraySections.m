//
//  ISCArraySections.m
//  iPhone Simulator Capture
//
//  Created by David Beck on 11/17/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import "ISCArraySections.h"


@implementation NSArray (ISCArraySections)

- (NSArray *)arrayWithSectionSize:(NSUInteger)sectionSize
{
	//a temporary holder that will eventually be the final array
	NSMutableArray *sectionedArray = [NSMutableArray arrayWithCapacity:[self count] / sectionSize];
	//a reference to the current section
	NSMutableArray *section = [NSMutableArray arrayWithCapacity:sectionSize];
	//go through each item and put it in a sub array
	for (id item in self) {
		//when the array is the size of sectionSize (could be ==, >= to be safe)
		if ([section count] >= sectionSize) {
			//save the current sub array to the final array
			[sectionedArray addObject:[NSArray arrayWithArray:section]];
			//create a new one (old will be autoreleased)
			section = [NSMutableArray arrayWithCapacity:sectionSize];
		}
		//we check the size first so that we don't add an empty array at the end
		[section addObject:item];
	}
	//make sure to get the last one
	[sectionedArray addObject:[section copy]];
	
	return [[sectionedArray copy] autorelease];
}

- (NSArray *)flatten
{
	NSMutableArray *flattenedArray = [NSMutableArray array];
	for (id object in self) {
		if ([object isKindOfClass:[NSArray class]]) {
			[flattenedArray addObjectsFromArray:object];
		} else {
			[flattenedArray addObject:object];
		}
	}
	return [[flattenedArray copy] autorelease];
}

@end
