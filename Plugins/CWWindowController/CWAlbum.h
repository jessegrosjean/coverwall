//
//  CWAlbum.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface CWAlbum : CALayer {
	NSMutableArray *tracks;
	CGImageRef artwork;
}

@property(readonly) NSArray *tracks;

- (CGImageRef)createAlbumArtwork:(CGSize)size;

@end
