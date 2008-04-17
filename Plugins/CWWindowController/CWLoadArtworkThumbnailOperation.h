//
//  CWLoadArtworkThumbnailOperation.h
//  CoverWall
//
//  Created by Jesse Grosjean on 4/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class CWAlbum;

@interface CWLoadArtworkThumbnailOperation : NSOperation {
	CWAlbum *album;
	CGSize size;
}

- (id)initWithAlbum:(CWAlbum *)album size:(CGSize)size;

@end
