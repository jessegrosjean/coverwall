//
//  CWCacheBuilder.h
//  CoverWall
//
//  Created by Jesse Grosjean on 4/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"


@interface CWCacheBuilder : NSObject {
	iTunesApplication *iTunes;
	NSError *scriptingBridgeError;
}

#pragma mark Class Methods

+ (id)sharedInstance;
	
- (void)updateCache;

@end
