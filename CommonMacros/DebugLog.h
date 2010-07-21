/*
 *  DebugLog.h
 *
 *  Created by David Beck on 1/3/2010.
 *  Copyright 2010 David Beck. All rights reserved.
 *
 */

//DEBUG can be turned on by either #define DEBUG or in the Xcode project setting as a Preprocessor Macro for the debug setting

#ifdef DEBUG
#	ifndef DebugLog
#		define DebugLog(...) NSLog(__VA_ARGS__)
#	endif
#
#	ifndef DebugAssert
#		define DebugAssert(...) NSAssert(__VA_ARGS__)
#	endif
#
#	ifndef DebugAbort
#		define DebugAbort() abort()
#	endif
#else
#	ifndef DebugLog
#		define DebugLog(...)
#	endif
#
#	ifndef DebugAssert
#		define DebugAssert(...)
#	endif
#
#	ifndef DebugAbort
#		define DebugAbort()
#	endif
#endif