//
//  IsEmpty.h
//
//  Created by David Beck on 12/29/2009.
//  Copyright 2009 David Beck. All rights reserved.
//

#import <Foundation/Foundation.h>

//http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
static inline BOOL IsEmpty(id thing) {
    return thing == nil
	|| ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
	|| ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}
//not a categorie because if the object was nil, you would not be able to call a method
