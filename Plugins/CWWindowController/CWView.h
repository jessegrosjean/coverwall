//
//  CWView.h
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CWView : NSView {
	NSImage *wallImage;
	NSPoint wallImageOrigin;
	NSSize wallImageSize;
//	CALayer *rootLayer;
}

//@property(retain) CALayer *rootLayer;
@property(retain) NSImage *wallImage;

- (NSRect)convertViewRectToWallImageRect:(NSRect)aRect;
- (NSRect)convertWallImageRectToViewRect:(NSRect)aRect;

@end
