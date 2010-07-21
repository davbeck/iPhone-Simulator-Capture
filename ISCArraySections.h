//
//  ISCArraySections.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 11/17/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSArray (ISCArraySections)

//returns an array of arrays with each sub array having a count of sectionSize
//all items from the original array will be in a sub array in order
- (NSArray *)arrayWithSectionSize:(NSUInteger)sectionSize;

- (NSArray *)flatten;

@end
