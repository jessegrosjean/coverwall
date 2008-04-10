//
//  CWWall.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWWall.h"

@implementation CWWall

@synthesize targetSize;

- (id)init {
	if (self = [super init]) {
		NSString *processesApplicationSupportFolder = [[NSFileManager defaultManager] processesApplicationSupportFolder];
		NSString *cacheFolder = [processesApplicationSupportFolder stringByAppendingPathComponent:@"Cache"];
		
		[[NSFileManager defaultManager] removeFileAtPath:cacheFolder handler:nil];
		[[NSFileManager defaultManager] createDirectoryAtPath:cacheFolder attributes:nil];
		
		[NSTask launchedTaskWithLaunchPath:[[[[NSBundle bundleForClass:[self class]] executablePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"CWCacheBuilder"] arguments:[NSArray arrayWithObject:cacheFolder]];
	}
	
	return self;
}



/*
NSURL *url = [NSURL fileURLWithPath:imagePath];
CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url,NULL);
if (source)
{
	NSDictionary* thumbOpts = [NSDictionary dictionaryWithObjectsAndKeys:
							   (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
							   (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
							   [NSNumber numberWithInt:MAX_THUMB_SIZE],
							   (id)kCGImageSourceThumbnailMaxPixelSize, 
							   nil];
	
	CGImageRef theCGImage = CGImageSourceCreateThumbnailAtIndex(
																source, 0, (CFDictionaryRef)thumbOpts);
	...
    CFRelease(theCGImage);
}
CFRelease(source);
}*/

- (void)setTargetSize:(NSSize)newTargetSize {
	targetSize = newTargetSize;
	actualSize = targetSize;

	CGFloat area = actualSize.width * actualSize.height;
	NSUInteger tracksCount = [self.tracks count];
	CGFloat trackArea = area / tracksCount;
	
	trackSize = (NSUInteger) sqrt(trackArea);
	columns = floor(actualSize.width / trackSize);
	rows = floor(actualSize.height / trackSize);
	
	while ((rows * columns) < tracksCount) {
		trackSize--;
		columns = floor(actualSize.width / trackSize);
		rows = floor(actualSize.height / trackSize);
	}
	
	actualSize.width = trackSize * columns;
	actualSize.height = trackSize * rows;
}

@synthesize actualSize;
@synthesize rows;
@synthesize columns;
@synthesize trackSize;
@synthesize tracks;

- (NSArray *)tracks {	
	if (!tracks) {		
		tracks = [NSMutableArray array];
		NSMutableSet *albumNames = [NSMutableSet set];
		
		for (iTunesSource *eachSource in [self.iTunes sources]) {
			for (iTunesAudioCDPlaylist *eachPlaylist in [eachSource libraryPlaylists]) {
				for (iTunesTrack *eachTrack in [eachPlaylist tracks]) {
					NSString *albumName = [eachTrack album];
					
					if (![albumNames containsObject:albumName]) {
						if ([[eachTrack artworks] count] > 0) {
							[tracks addObject:eachTrack];
							[albumNames addObject:albumName];
						}
					}
				}
			}
		}
	}
	return tracks;
}

- (iTunesApplication *)iTunes {
	if (!iTunes) {
		iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];		
		iTunes.delegate = self;
	}
	return iTunes;
}

- (iTunesTrack *)trackAtPoint:(NSPoint)point {
	return 0;
}

- (NSRect)rectForTrack:(iTunesTrack *)track {
	NSUInteger trackIndex = [self.tracks indexOfObject:track];
	
	if (trackIndex != NSNotFound) {
		for (NSUInteger row = 0; row < rows; row++) {
			for (NSUInteger column = 0; column < columns; column++) {
				if (trackIndex == 0) {
					return [self rectForRow:row columns:column];
				}
				trackIndex--;
			}
		}
	}
	
	return NSZeroRect;
}

- (NSRect)rectForRow:(NSUInteger)aRow columns:(NSUInteger)aColumn {
	NSRect rect = NSMakeRect(0, 0, trackSize, trackSize);
	rect.origin.x = (trackSize * aColumn);
	rect.origin.y = ((rows - 1) * trackSize) - (trackSize * aRow);
	return rect;
}

- (void)processWallWithDelegate:(id)delegate {
	currentDelegate = delegate;
		
	[delegate wallWillBeginProcessing:self];
		
	for (iTunesTrack *eachTrack in self.tracks) {
		currentTrack = eachTrack;
		[delegate wall:self processTrack:eachTrack];;
	}
		
	[delegate wallWillEndProcessing:self];
	
	currentDelegate = nil;
}

- (void)eventDidFail:(const AppleEvent *)event withError:(NSError *)error {
	[currentDelegate wall:self error:error processingTrack:currentTrack];
	scriptingBridgeError = error;
}
		 
@end
