#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface QTMovie (QTMovieExtensions)

- (void)addImage:(NSImage *)image withDuration:(NSTimeInterval)duration;

@end