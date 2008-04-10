//
//  CWView.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CWView

- (void)awakeFromNib {
//	self.wantsLayer = YES;
//	rootLayer = self.layer;
//	rootLayer.delegate = self;
}

//@synthesize rootLayer;
@synthesize wallImage;

- (void)setWallImage:(NSImage *)newWallImage {
	wallImage = newWallImage;	
	wallImageSize = [wallImage size];
	NSRect bounds = [self bounds];
	wallImageOrigin.x = (NSUInteger) ((bounds.size.width - wallImageSize.width) / 2.0);
	wallImageOrigin.y = (NSUInteger) ((bounds.size.height - wallImageSize.height) / 2.0);
//	[self.rootLayer setNeedsDisplay];
}

//- (void)setRootLayerNeedsDisplayInRect:(NSRect)aRect {
//	[self.rootLayer setNeedsDisplay];
//	[self.rootLayer setNeedsDisplayInRect:CGRectMake(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height)];
//}

- (void)drawRect:(NSRect)rect {
	[[NSColor blackColor] set];
	NSRectFill(rect);	
	[wallImage compositeToPoint:wallImageOrigin operation:NSCompositeSourceOver];
}

- (NSRect)convertViewRectToWallImageRect:(NSRect)aRect {
	aRect.origin.x -= wallImageOrigin.x;
	aRect.origin.y -= wallImageOrigin.y;
	return aRect;
}

- (NSRect)convertWallImageRectToViewRect:(NSRect)aRect {
	aRect.origin.x += wallImageOrigin.x;
	aRect.origin.y += wallImageOrigin.y;
	return aRect;
}

@end
