//
//  CWLibrary.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWLibrary.h"
#import "CWTrack.h"
#import "CWAlbum.h"
#import "CWArtist.h"


@interface CWArtist (CWLibraryPrivate)
- (id)initWithName:(NSString *)aName;
@end

@interface CWAlbum (CWLibraryPrivate)
- (id)initWithName:(NSString *)aName;
- (void)sortTracks;
@end

@implementation CWLibrary

#pragma mark Class Methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

+ (NSString *)libraryXMLPath {
	NSString *path = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.apple.iApps.plist"]];
	
	if (preferences) {
		path = [[NSURL URLWithString:[[preferences valueForKey:@"iTunesRecentDatabases"] lastObject]] path];
	}
	
	if (!path || ![fileManager fileExistsAtPath:path]) {
		path = [NSHomeDirectory() stringByAppendingPathComponent:@"Music/iTunes/iTunes Music Library.xml"];		
		if (![fileManager fileExistsAtPath:path]) {
			path = nil;
		}
	}
	
	return path;
}

#pragma mark Init

- (id)init {
	[super init];
	artists = [[NSMutableArray alloc] init];
	albums = [[NSMutableArray alloc] init];
	tracks = [[NSMutableArray alloc] init];
	namesToArtists = [[NSMutableDictionary alloc] init];
	namesToAlbums = [[NSMutableDictionary alloc] init];
	return self;
}

@synthesize artists;

- (id)artistWithName:(NSString *)aName {
	if (!aName) aName = @"Unknown Artist";
	CWArtist *artist = [namesToArtists objectForKey:aName];
	if (!artist) {
		artist = [[CWArtist alloc] initWithName:aName];
		[namesToArtists setObject:artist forKey:aName];
		[artists addObject:artist];
	}
	return artist;
}

@synthesize albums;

- (id)albumWithName:(NSString *)aName {
	if (!aName) aName = @"Unknown Artist";
	CWAlbum *album = [namesToAlbums objectForKey:aName];
	if (!album) {
		album = [[CWAlbum alloc] initWithName:aName];
		[namesToAlbums setObject:album forKey:aName];
		[albums addObject:album];
	}
	return album;
}

@synthesize tracks;

- (void)reload {
	[artists removeAllObjects];
	[albums removeAllObjects];
	[tracks removeAllObjects];
	[namesToArtists removeAllObjects];
	[namesToAlbums removeAllObjects];
	
	NSDictionary *libraryDictionary = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[CWLibrary libraryXMLPath]] mutabilityOption:NSPropertyListMutableContainersAndLeaves format:NULL errorDescription:NULL];
	NSArray *trackDictionaries = [[libraryDictionary objectForKey:@"Tracks"] allValues];
	
	for (NSMutableDictionary *eachTrackDictionary in trackDictionaries) {
		[tracks addObject:[[[CWTrack alloc] initWithTrackDictionary:eachTrackDictionary] autorelease]];
	}
	
	[albums makeObjectsPerformSelector:@selector(sortTracks)];
}

- (void)clearLayer {
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
	[[[[self sublayers] copy] autorelease] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
	[CATransaction commit];	
}

@end

@implementation CWArtist (CWLibraryPrivate)

- (id)initWithName:(NSString *)aName {
	[super init];
	self.name = aName;
	albums = [[NSMutableArray alloc] init];
	return self;
}

@end

@implementation CWAlbum (CWLibraryPrivate)

- (id)initWithName:(NSString *)aName {
	[super init];
	self.name = aName;
	self.anchorPoint = CGPointMake(0, 0);
	tracks = [[NSMutableArray alloc] init];
	return self;
}

- (void)sortTracks {
	[tracks sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"trackNumber" ascending:YES]]];
}

@end