//
//  main.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/8/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CWCacheBuilder.h"


int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[NSApplication sharedApplication];
	[[CWCacheBuilder sharedInstance] updateCache];
	[pool release];
	return 0;
}
