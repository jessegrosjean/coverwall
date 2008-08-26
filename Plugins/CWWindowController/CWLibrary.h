//
//  CWLibrary.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@class CWTrack;
@class CWArtist;
@class CWAlbum;

@interface CWLibrary : NSObject {
	NSMutableArray *artists;
	NSMutableArray *albums;
	NSMutableArray *tracks;
	NSMutableDictionary *namesToArtists;
	NSMutableDictionary *namesToAlbums;
}

#pragma mark Class Methods

+ (id)sharedInstance;
+ (NSString *)cacheFolder;
+ (NSMutableDictionary *)libraryXML;
	
@property(readonly) NSArray *artists;
- (CWArtist *)artistForTrack:(CWTrack *)aTrack;
@property(readonly) NSArray *albums;
- (CWAlbum *)albumForTrack:(CWTrack *)aTrack;
@property(readonly) NSArray *tracks;

- (void)reload;

@end
