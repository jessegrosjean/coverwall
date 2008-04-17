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


@interface CWAlbum (CWTrackPrivate)
- (void)addTrack:(CWTrack *)aTrack;
@end

@implementation CWTrack

- (id)initWithTrackDictionary:(NSDictionary *)trackDictionary {
	[super init];
	CWLibrary *library = [CWLibrary sharedInstance];
	persistentID = [[trackDictionary valueForKey:@"Persistent ID"] retain];
	location = [[trackDictionary objectForKey:@"Location"] retain];
	self.name = [trackDictionary valueForKey:@"Name"];
	trackNumber = [[trackDictionary valueForKey:@"Track Number"] integerValue];	
	artist = [[library artistWithName:[trackDictionary valueForKey:@"Artist"]] retain];
	album = [[library albumWithName:[trackDictionary valueForKey:@"Album"]] retain];
	[album addTrack:self];
	return self;
}

- (void)dealloc {
	[persistentID release];
	[location release];
	[artist release];
	[album release];
	[super dealloc];
}

@synthesize persistentID;
@synthesize location;
@synthesize trackNumber;
@synthesize artist;
@synthesize album;

- (CGImageRef)createTrackArtwork:(CGSize)size {
	if (location) {
		NSURL *locationURL = [NSURL URLWithString:location];
		CGImageRef imageRef = QLThumbnailImageCreate(kCFAllocatorDefault, (CFURLRef)locationURL, size, NULL);
		if (!imageRef) {
			NSString *path = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"Cover Missing"];
			locationURL = [NSURL fileURLWithPath:path];
			imageRef = QLThumbnailImageCreate(kCFAllocatorDefault, (CFURLRef)locationURL, size, NULL);
/*			NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:[locationURL path]];
			if (image) {
				[image setSize:NSMakeSize(size.width, size.height)];
				[image lockFocus];
				NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0,0,size.width,size.height)];
				[image unlockFocus];
				imageRef = [bitmapImageRep CGImage];
				CFRetain(imageRef);
			}*/
		}
		return imageRef;
	}
	
	return NULL;
}

@end

@implementation CWAlbum (CWTrackPrivate)

- (void)addTrack:(CWTrack *)aTrack {
	[tracks addObject:aTrack];
}

@end
