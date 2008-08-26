//
//  CWTrack.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "BDocuments.h"


@class CWArtist;
@class CWAlbum;

@interface CWTrack : NSObject {
	NSDictionary *trackDictionary;
	CWArtist *artist;
	CWAlbum *album;
}

- (id)initWithTrackDictionary:(NSDictionary *)aTrackDictionary;

@property(readonly) NSInteger trackID;
@property(readonly) NSString *name;
@property (readonly) NSString *sortName;
@property (readonly) CWArtist *artist;
@property (readonly) NSString *artistName;
@property (readonly) NSString *sortArtist;
@property (readonly) CWAlbum *album;
@property (readonly) NSString *albumName;
@property (readonly) NSString *sortAlbum;
@property (readonly) NSInteger albumRating;
@property (readonly) NSString *genre;
@property (readonly) NSString *kind;
@property (readonly) NSInteger size;
@property (readonly) NSInteger totalTime;
@property (readonly) NSInteger trackNumber;
@property (readonly) NSInteger year;
@property (readonly) NSDate *dateModified;
@property (readonly) NSDate *dateAdded;
@property (readonly) NSInteger bitRate;
@property (readonly) NSInteger sampleRate;
@property (readonly) NSInteger playCount;
@property (readonly) NSDate *playDate;
@property (readonly) NSInteger rating;
@property (readonly) NSString *comments;
@property (readonly) NSDate *releaseDate;
@property (readonly) NSInteger artworkCount;
@property (readonly) NSString *persistentID;
@property (readonly) NSString *trackType;
@property (readonly) BOOL podcast;
@property (readonly) BOOL book;
@property (readonly) BOOL movie;
@property (readonly) BOOL tvShow;
@property (readonly) BOOL unplayed;
@property (readonly) BOOL hasVideo;
@property (readonly) NSURL *location;

//- (NSURL *)artworkPath;

- (NSData *)artwork;
- (NSString *)artworkPath;

@end
