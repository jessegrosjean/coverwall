//
//  CWLoadArtworkThumbnailOperation.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWLoadArtworkThumbnailOperation.h"
#import "CWAlbum.h"


@implementation CWLoadArtworkThumbnailOperation

- (id)initWithAlbum:(CWAlbum *)anAlbum size:(CGSize)aSize {
	[super init];
	album = anAlbum;
	size = aSize;
	return self;
}

- (void)setContents:(CGImageRef)newContents {
	if (![self isCancelled]) {
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
		album.contents = (id)newContents;
		[CATransaction commit];	
	}
	
	if (newContents) {
		CFRelease(newContents);
	}
	NSLog(@"performed artwork load");
}

- (void)main {
	[self performSelectorOnMainThread:@selector(setContents:) withObject:(id)[album createAlbumArtwork:size] waitUntilDone:YES];
	NSLog(@"finished artwork load");
}

@end
