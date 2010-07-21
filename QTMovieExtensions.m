#import "QTMovieExtensions.h"


@implementation QTMovie (QTMovieExtensions)

//a simple wrapper method to the built in addImage
//sets up a QTTime based on duration
//uses a default of png compression
- (void)addImage:(NSImage *)image withDuration:(NSTimeInterval)duration
{
	QTTime time = QTMakeTime((long long)(duration * 1000.0), 1000);
	//by using png, the video will have transparency
	NSDictionary *attrs = [[NSDictionary alloc] initWithObjectsAndKeys:@"png ", QTAddImageCodecType, nil];
	[self addImage:image forDuration:time withAttributes:attrs];
	[attrs release];
}

@end
