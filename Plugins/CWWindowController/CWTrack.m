//
//  CWTrack.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWTrack.h"
#import "CWArtist.h"
#import "CWAlbum.h"
#import "CWLibrary.h"
#import <QuickLook/QuickLook.h>


typedef enum {
    kITAccessArtworkFormatJPEG = 13
} ITAccessArtworkFormat;

typedef void* ITAccessContextRef;
OSErr ITAccessContextCreate(CFAllocatorRef allocator, ITAccessContextRef *context) __attribute__((weak_import));
//void ITAccessContextRetain(ITAccessContextRef context) __attribute__((weak_import));
void ITAccessContextRelease(ITAccessContextRef context) __attribute__((weak_import));
OSErr ITAccessCopyArtworkWithURL(ITAccessContextRef context, CFURLRef itunesFileURL, CFDictionaryRef options, CFDataRef *artworkData, ITAccessArtworkFormat *format) __attribute__((weak_import));


@interface CWAlbum (CWTrackPrivate)
- (void)addTrack:(CWTrack *)aTrack;
@end

@implementation CWTrack

- (id)initWithTrackDictionary:(NSDictionary *)aTrackDictionary {
	[super init];
	trackDictionary = aTrackDictionary;

	self.album;
	self.artist;
	/*
	CWLibrary *library = [CWLibrary sharedInstance];
	persistentID = [trackDictionary valueForKey:@"Persistent ID"];
	location = [trackDictionary objectForKey:@"Location"];
	name = [trackDictionary valueForKey:@"Name"];
	trackNumber = [[trackDictionary valueForKey:@"Track Number"] integerValue];	
	artist = [library artistWithName:[trackDictionary valueForKey:@"Artist"]];
	album = [library albumWithName:[trackDictionary valueForKey:@"Album"]];
	[album addTrack:self];*/
	return self;
}

- (NSInteger)trackID {
	return [[trackDictionary valueForKey:@"Track ID"] integerValue];
}

- (NSString *)name {
	return [trackDictionary valueForKey:@"Name"];
}

- (NSString *)sortName {
	return [trackDictionary valueForKey:@"Sort Name"];
}

- (CWArtist *)artist {
	if (!artist) {
		artist = [[CWLibrary sharedInstance] artistForTrack:self];
	}
	return artist;
}

- (NSString *)artistName {
	return [trackDictionary valueForKey:@"Artist"];
}

- (NSString *)sortArtist {
	return [trackDictionary valueForKey:@"Sort Artist"];
}

- (CWAlbum *)album {
	if (!album) {
		album = [[CWLibrary sharedInstance] albumForTrack:self];
		[album addTrack:self];
	}
	return album;
}

- (NSString *)albumName {
	return [trackDictionary valueForKey:@"Album"];
}

- (NSString *)sortAlbum {
	return [trackDictionary valueForKey:@"Sort Album"];
}

- (NSInteger)albumRating {
	return [[trackDictionary valueForKey:@"Album Rating"] integerValue];
}

- (NSString *)genre {
	return [trackDictionary valueForKey:@"Genre"];
}

- (NSString *)kind {
	return [trackDictionary valueForKey:@"Kind"];
}

- (NSInteger)size {
	return [[trackDictionary valueForKey:@"Size"] integerValue];
}

- (NSInteger)totalTime {
	return [[trackDictionary valueForKey:@"Total Time"] integerValue];
}

- (NSInteger)trackNumber {
	return [[trackDictionary valueForKey:@"Track Number"] integerValue];
}

- (NSInteger)year {
	return [[trackDictionary valueForKey:@"Year"] integerValue];
}

- (NSDate *)dateModified {
	return [trackDictionary valueForKey:@"Date Modified"];
}

- (NSDate *)dateAdded {
	return [trackDictionary valueForKey:@"Date Added"];
}

- (NSInteger)bitRate {
	return [[trackDictionary valueForKey:@"Bit Rate"] integerValue];
}

- (NSInteger)sampleRate {
	return [[trackDictionary valueForKey:@"Sample Rate"] integerValue];
}

- (NSInteger)playCount {
	return [[trackDictionary valueForKey:@"Play Count"] integerValue];
}

- (NSDate *)playDate {
	return [trackDictionary valueForKey:@"Play Date"];
}

- (NSInteger)rating {
	return [[trackDictionary valueForKey:@"Rating"] integerValue];
}

- (NSString *)comments {
	return [trackDictionary valueForKey:@"Comments"];
}

- (NSDate *)releaseDate {
	return [trackDictionary valueForKey:@"Release Date"];
}

- (NSInteger)artworkCount {
	return [[trackDictionary valueForKey:@"Artwork Count"] integerValue];
}

- (NSString *)persistentID {
	return [trackDictionary valueForKey:@"Persistent ID"];
}

- (NSString *)trackType {
	return [trackDictionary valueForKey:@"Track Type"];
}

- (BOOL)podcast {
	return [[trackDictionary valueForKey:@"Podcast"] boolValue];
}

- (BOOL)book {
	return [[trackDictionary valueForKey:@"Book"] boolValue];
}

- (BOOL)movie {
	return [[trackDictionary valueForKey:@"Movie"] boolValue];
}

- (BOOL)tvShow {
	return [[trackDictionary valueForKey:@"TV Show"] boolValue];
}

- (BOOL)unplayed {
	return [[trackDictionary valueForKey:@"Unplayed"] boolValue];
}

- (BOOL)hasVideo {
	return [[trackDictionary valueForKey:@"Has Video"] boolValue];
}

- (NSURL *)location {
	NSString *location = [trackDictionary valueForKey:@"Location"];
	if (location) {
		return [NSURL URLWithString:location];
	}
	return nil;
}

/*
- (NSURL *)artworkPath {
	[self artwork];
	
	static NSURL *GenericCoverMissingPath = nil;
	static NSURL *PodcastCoverMissingPath = nil;
	static NSURL *MovieCoverMissingPath = nil;
	static NSURL *BookCoverMissingPath = nil;
	static NSURL *TVCoverMissingPath = nil;
	
	if (!GenericCoverMissingPath) {
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		TVCoverMissingPath = [NSURL fileURLWithPath:[bundle pathForImageResource:@"Cover Missing (TV)"]];
		PodcastCoverMissingPath = [NSURL fileURLWithPath:[bundle pathForImageResource:@"Cover Missing (Podcast)"]];
		MovieCoverMissingPath = [NSURL fileURLWithPath:[bundle pathForImageResource:@"Cover Missing (Movie)"]];
		BookCoverMissingPath = [NSURL fileURLWithPath:[bundle pathForImageResource:@"Cover Missing (Book)"]];
		GenericCoverMissingPath = [NSURL fileURLWithPath:[bundle pathForImageResource:@"Cover Missing"]];
	}
		
	NSURL *location = self.location;
	
	if (location) {
		CGImageRef imageRef = QLThumbnailImageCreate(kCFAllocatorDefault, (CFURLRef)location, CGSizeMake(24, 24), NULL); // test to see if valid quicklook path.
		
		if (imageRef) {
			CFRelease(imageRef);
			return location;
		}
	}

	if (self.podcast) {
		location = PodcastCoverMissingPath; 
	} else if (self.book) {
		location = BookCoverMissingPath; 
	} else if (self.movie) {
		location = MovieCoverMissingPath; 
	} else if (self.tvShow) {
		location = TVCoverMissingPath; 
	} else {
		location = GenericCoverMissingPath; 
	}
	
	return location;
}
*/

- (NSData *)artwork {
    if (!ITAccessContextCreate || !ITAccessContextRelease || !ITAccessCopyArtworkWithURL) {
		// try with QLThumbnailImageCreate?
	} else {
		static ITAccessContextRef iTunesAccessContext = NULL;
		
		if (!iTunesAccessContext && ITAccessContextCreate(kCFAllocatorDefault, &iTunesAccessContext) != noErr)
			return nil;
		
		NSData *plainCoverImageData = nil;
		ITAccessArtworkFormat format;
		
		OSErr result = ITAccessCopyArtworkWithURL(iTunesAccessContext, (CFURLRef)self.location, NULL, (CFDataRef *)&plainCoverImageData, &format);
		
		if (result == noErr) {
			plainCoverImageData = [(NSData *)plainCoverImageData autorelease];
		} else if (result != fnfErr) { // not finding the artwork is a common error we don't really care about
			NSLog(@"iTunesAccess error: %i", result);
		}
		
		return plainCoverImageData;
	}
 
	return nil;
}

- (NSString *)artworkPath {
	static NSString *GenericCoverMissingPath = nil;
	static NSString *PodcastCoverMissingPath = nil;
	static NSString *MovieCoverMissingPath = nil;
	static NSString *BookCoverMissingPath = nil;
	static NSString *TVCoverMissingPath = nil;
	
	if (!GenericCoverMissingPath) {
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		TVCoverMissingPath = [bundle pathForImageResource:@"Cover Missing (TV)"];
		PodcastCoverMissingPath = [bundle pathForImageResource:@"Cover Missing (Podcast)"];
		MovieCoverMissingPath = [bundle pathForImageResource:@"Cover Missing (Movie)"];
		BookCoverMissingPath = [bundle pathForImageResource:@"Cover Missing (Book)"];
		GenericCoverMissingPath = [bundle pathForImageResource:@"Cover Missing"];
	}
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [[CWLibrary cacheFolder] stringByAppendingPathComponent:self.persistentID];

	if (![fileManager fileExistsAtPath:path]) {
		NSData *artwork = [self artwork];
		if (artwork) {
			[artwork writeToFile:path atomically:YES];
		} else {
			NSString *missingArtworkPath = nil;
			
			if (self.podcast) {
				missingArtworkPath = PodcastCoverMissingPath; 
			} else if (self.book) {
				missingArtworkPath = BookCoverMissingPath; 
			} else if (self.movie) {
				missingArtworkPath = MovieCoverMissingPath; 
			} else if (self.tvShow) {
				missingArtworkPath = TVCoverMissingPath; 
			} else {
				missingArtworkPath = GenericCoverMissingPath; 
			}
			
			[fileManager copyPath:missingArtworkPath toPath:path handler:nil];
		}
	}
	
	return path;
}

@end

@implementation CWAlbum (CWTrackPrivate)

- (void)addTrack:(CWTrack *)aTrack {
	[tracks addObject:aTrack];
}

@end
