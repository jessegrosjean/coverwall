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
- (id)initWithName:(NSString *)aName track:(CWTrack *)aTrack;
- (void)sortAlbums;
@end

@interface CWAlbum (CWLibraryPrivate)
- (id)initWithName:(NSString *)aName track:(CWTrack *)aTrack;
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

+ (NSString *)cacheFolder {
    static NSString *cacheFolder = nil;
	if (cacheFolder == nil) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		cacheFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"CoverwallCache"];
		
		if (![fileManager fileExistsAtPath:cacheFolder]) {
			[fileManager createDirectoryAtPath:cacheFolder attributes:nil];
		}
	}
	return cacheFolder;
}

+ (NSMutableDictionary *)libraryXML {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *cachedLibraryXMLPath = [[self cacheFolder] stringByAppendingPathComponent:@"cachedLibraryXML.plist"];
	
	if ([fileManager fileExistsAtPath:cachedLibraryXMLPath]) {
		return [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:cachedLibraryXMLPath] mutabilityOption:NSPropertyListMutableContainersAndLeaves format:nil errorDescription:nil];
	} else {
		NSString *path = nil;
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

		if (path) {
			NSMutableDictionary *result = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:path] mutabilityOption:NSPropertyListMutableContainersAndLeaves format:NULL errorDescription:NULL];
			NSData *data = [NSPropertyListSerialization dataFromPropertyList:result format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
			[data writeToFile:cachedLibraryXMLPath atomically:NO];
			return result;
		}
	}
	return nil;
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

- (CWArtist *)artistForTrack:(CWTrack *)aTrack {
	NSString *artistName = aTrack.artistName;
	if (!artistName) artistName = @"Unknown Artist";
	CWArtist *artist = [namesToArtists objectForKey:artistName];
	if (!artist) {
		artist = [[CWArtist alloc] initWithName:artistName track:aTrack];
		[namesToArtists setObject:artist forKey:artistName];
		[artists addObject:artist];
	}
	return artist;
}

@synthesize albums;

- (CWAlbum *)albumForTrack:(CWTrack *)aTrack {
	NSString *albumName = aTrack.albumName;
	if (!albumName) albumName = @"Unknown Album";
	CWAlbum *album = [namesToAlbums objectForKey:albumName];
	if (!album) {
		album = [[CWAlbum alloc] initWithName:albumName track:aTrack];
		[namesToAlbums setObject:album forKey:albumName];
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
	
	NSMutableDictionary *libraryDictionary = [CWLibrary libraryXML];
	NSArray *trackDictionaries = [[libraryDictionary objectForKey:@"Tracks"] allValues];
	
	for (NSMutableDictionary *eachTrackDictionary in trackDictionaries) {
		[tracks addObject:[[CWTrack alloc] initWithTrackDictionary:eachTrackDictionary]];
	}
	
	[artists sortUsingDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"sortName" ascending:YES], nil]];
	[artists makeObjectsPerformSelector:@selector(sortAlbums)];
	[albums sortUsingDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"sortName" ascending:YES], nil]];
	[albums makeObjectsPerformSelector:@selector(sortTracks)];
}

@end

@implementation CWArtist (CWLibraryPrivate)

- (id)initWithName:(NSString *)aName track:(CWTrack *)aTrack {
	[super init];
	name = aName;
	sortName = aTrack.sortArtist == nil ? name : aTrack.sortArtist;
	albums = [[NSMutableArray alloc] init];
	return self;
}

- (void)sortAlbums {
	[albums sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"sortName" ascending:YES]]];
}

@end

@implementation CWAlbum (CWLibraryPrivate)

- (id)initWithName:(NSString *)aName track:(CWTrack *)aTrack {
	[super init];
	name = aName;
	sortName = aTrack.sortAlbum == nil ? name : aTrack.sortAlbum;
	tracks = [[NSMutableArray alloc] init];
	return self;
}

- (void)sortTracks {
	[tracks sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"trackNumber" ascending:YES]]];
}

@end