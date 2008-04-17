//
//  CWAlbum.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWAlbum.h"
#import "CWLibrary.h"
#import "CWTrack.h"

@implementation CWAlbum

- (void)dealloc {
	[tracks release];
	[super dealloc];
}

@synthesize tracks;

- (CGImageRef)createAlbumArtwork:(CGSize)size {
	if ([tracks count] > 0) {
		CGImageRef imageRef = [[tracks objectAtIndex:0] createTrackArtwork:size];
		if (imageRef) {
			return imageRef;
		}
	}
	return nil;
}

- (NSString *)imageUID {
	return [[tracks objectAtIndex:0] persistentID];
}

- (NSString *)imageRepresentationType {
	return IKImageBrowserCGImageRepresentationType;
}

- (id)imageRepresentation {
	if (!artwork) {
		artwork = [[tracks objectAtIndex:0] createTrackArtwork:CGSizeMake(128, 128)];
	}
	return (id) artwork;
}

@end