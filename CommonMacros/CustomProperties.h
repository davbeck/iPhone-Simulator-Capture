//
//  CustomProperties.h
//  GVKit
//
//  Created by David Beck on 4/11/10.
//  Copyright 2010 David Beck. All rights reserved.
//

#import <Foundation/Foundation.h>


id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic);
void objc_setProperty(id self, SEL _cmd, ptrdiff_t offset, id newValue, BOOL atomic, BOOL shouldCopy);
void objc_copyStruct(void *dest, const void *src, ptrdiff_t size, BOOL atomic, BOOL hasStrong);


#define AtomicRetainedSet(dest, source) \
objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, NO)
#define AtomicCopiedSet(dest, source) \
objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, YES)
#define AtomicAutoreleasedGet(source) \
objc_getProperty(self, _cmd, (ptrdiff_t)(&source) - (ptrdiff_t)(self), YES)
#define AtomicStruct(dest, source) \
objc_copyStruct(&dest, &source, sizeof(__typeof__(source)), YES, NO)
