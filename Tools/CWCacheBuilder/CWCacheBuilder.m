//
//  CWCacheBuilder.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWCacheBuilder.h"


@implementation CWCacheBuilder

#pragma mark Class Methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (iTunesApplication *)iTunes {
	if (!iTunes) {
		iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];		
		iTunes.delegate = self;
	}
	return iTunes;
}

- (void)updateCache {
	NSString *cacheDirectory = [[[NSProcessInfo processInfo] arguments] lastObject];
	NSDictionary *library = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[@"~/Music/iTunes/iTunes Music Library.xml" stringByExpandingTildeInPath]] mutabilityOption:NSPropertyListMutableContainersAndLeaves format:NULL errorDescription:NULL];
	NSArray *trackDictionaries = [[library objectForKey:@"Tracks"] allValues];
	NSMutableDictionary *persistentIDsToTrackDictionaries = [NSMutableDictionary dictionary];
	NSMutableDictionary *albumsToTrackDictionaries = [NSMutableDictionary dictionary];

	for (NSMutableDictionary *eachTrackDictionary in trackDictionaries) {
		NSString *album = [eachTrackDictionary objectForKey:@"Album"];
		if (!album) {
			album = @"Untitled Album";
			[eachTrackDictionary setObject:album forKey:@"Album"];
		}
		
		[persistentIDsToTrackDictionaries setObject:eachTrackDictionary forKey:[eachTrackDictionary valueForKey:@"Persistent ID"]];
		NSMutableArray *albumTracks = [albumsToTrackDictionaries objectForKey:album];
		if (!albumTracks) {
			albumTracks = [NSMutableArray array];
			[albumsToTrackDictionaries setObject:albumTracks forKey:album];
		}
		[albumTracks addObject:eachTrackDictionary];
	}

	NSNumber *artworkCount = [NSNumber numberWithInteger:1];
	NSMutableSet *discoveredAlbums = [NSMutableSet set];
	NSMutableArray *failedAlbums = [NSMutableArray array];
	NSDictionary *jpegProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.9], NSImageCompressionFactor, nil];
	
	for (iTunesSource *eachSource in [self.iTunes sources]) {
		SBElementArray *libraryPlaylists = [[eachSource libraryPlaylists] retain];
		
		for (iTunesAudioCDPlaylist *eachPlaylist in libraryPlaylists) {
			for (iTunesTrack *eachTrack in [eachPlaylist tracks]) {
				NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
				NSString *persistentID = [eachTrack persistentID];
				NSMutableDictionary *eachTrackDictionary = [persistentIDsToTrackDictionaries objectForKey:persistentID];
				NSString *album = [eachTrackDictionary objectForKey:@"Album"];
				
				if (![discoveredAlbums containsObject:album]) {
					[discoveredAlbums addObject:album];
					
					SBElementArray *artworks = [eachTrack artworks];
					
					if ([artworks count] > 0) {
						iTunesArtwork *artwork = [artworks objectAtIndex:0];
						NSImage *artworkImage = [artwork data];
						
						if (!scriptingBridgeError) {
							NSData *TIFFRepresentation = [artworkImage TIFFRepresentation];
							NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:TIFFRepresentation];
							//	NSData *jpeg2000Data = [bitmapImageRep representationUsingType:NSJPEG2000FileType properties:jpegProperties];
							NSData *jpegData = [bitmapImageRep representationUsingType:NSJPEGFileType properties:jpegProperties];
							NSString *writePath = [NSString stringWithFormat:@"%@/%@.jpeg", cacheDirectory, album];
							
							if ([jpegData writeToFile:writePath atomically:NO]) {
								for (NSMutableDictionary *eachTrackDictionary in [albumsToTrackDictionaries objectForKey:album]) {
									[eachTrackDictionary setObject:artworkCount forKey:@"Artwork Count"];
								}
							} else {
								for (NSMutableDictionary *eachTrackDictionary in [albumsToTrackDictionaries objectForKey:album]) {
									[eachTrackDictionary removeObjectForKey:@"Artwork Count"];
								}
								[failedAlbums addObject:album];
							}
						}
					}
				}
				
				scriptingBridgeError = nil;
				
				[pool release];
			}
		}
	}
	
	[[NSPropertyListSerialization dataFromPropertyList:trackDictionaries format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL] writeToFile:[cacheDirectory stringByAppendingPathComponent:@"tracks.plist"] atomically:YES];
	[[NSPropertyListSerialization dataFromPropertyList:failedAlbums format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL] writeToFile:[cacheDirectory stringByAppendingPathComponent:@"failedAlbums.plist"] atomically:YES];
}

- (void)eventDidFail:(const AppleEvent *)event withError:(NSError *)error {
	scriptingBridgeError = error;
}

@end
