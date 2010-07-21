//
//  ImageRect.h
//  iPhone Simulator Capture
//
//  Created by David Beck on 10/15/09.
//  Copyright 2009 David Beck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define NSRectToCGRect(r) CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height)

@interface NSImage (ImageRect)

- (NSRect)bounds;

- (void)drawAtPoint:(NSPoint)location
		   fraction:(CGFloat)opacity;

@end
