//
//  CWTrack.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@class CWArtist;
@class CWAlbum;

@interface CWTrack : CALayer {
	NSString *persistentID;
	NSString *location;
	NSInteger trackNumber;
	CWArtist *artist;
	CWAlbum *album;
}

- (id)initWithTrackDictionary:(NSDictionary *)trackDictionary;

@property (readonly) NSString *persistentID;
@property (readonly) NSString *location;
@property (readonly) NSInteger trackNumber;
@property (readonly) CWArtist *artist;
@property (readonly) CWAlbum *album;

- (CGImageRef)createTrackArtwork:(CGSize)size;

@end
