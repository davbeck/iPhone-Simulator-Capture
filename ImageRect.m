//
//  ImageRect.m
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/15/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import "ImageRect.h"


@implementation NSImage (ImageRect)

- (NSRect)bounds
{
	NSRect imageRect;
	imageRect.origin = NSZeroPoint;
	imageRect.size = [self size];
	return imageRect;
}

- (void)drawAtPoint:(NSPoint)location
		   fraction:(CGFloat)opacity
{
	[self drawAtPoint:location 
			 fromRect:[self bounds] 
			operation:NSCompositeSourceOver 
			 fraction:opacity];
}

@end
