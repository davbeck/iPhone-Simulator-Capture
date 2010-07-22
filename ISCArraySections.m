//
//  ISCArraySections.m
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
