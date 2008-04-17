//
//  CWUpdateLibraryOperation.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWUpdateLibraryOperation.h"
#import "CWLibraryView.h"
#import "CWLibrary.h"
#import "CWAlbum.h"
#import "CWLoadArtworkThumbnailOperation.h"


@implementation CWUpdateLibraryOperation

- (id)initWithLibrary:(CWLibrary *)aLibrary {
	[super init];
	library = [aLibrary retain];
	loadArtworkOperationQueue = [[NSOperationQueue alloc] init];
	return self;
}

- (void)addAlbum:(CWAlbum *)album {
	
	if (![self isCancelled]) {
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
		[library addSublayer:album];
		[CATransaction commit];		
		[library setNeedsDisplayInRect:album.frame];
	}
}

- (void)cancel {
	[super cancel];
	[loadArtworkOperationQueue cancelAllOperations];
}

- (void)main {
	NSUInteger rows;
	NSUInteger columns;
	NSUInteger albumSize;
	NSRect bounds = [library.delegate bounds];
	NSArray *visibleAlbums = [library.albums filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"contents != NULL"]];
	
	[CWLibraryView calculateRows:&rows columns:&columns albumSize:&albumSize forAlbumCount:[visibleAlbums count] inBounds:bounds];
	
	NSInteger xOffset = (bounds.size.width - (columns * albumSize)) / 2;
	NSInteger yOffset = (bounds.size.height - (rows * albumSize)) / 2;	
	NSUInteger row = rows - 1;
	NSUInteger column = 0;
	NSSortDescriptor *artistNameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"artist.name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
	NSSortDescriptor *albumNameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
	visibleAlbums = [visibleAlbums sortedArrayUsingDescriptors:[NSArray arrayWithObjects:albumNameSortDescriptor, artistNameSortDescriptor, nil]];
	
	for (CWAlbum *eachAlbum in visibleAlbums) {
		[eachAlbum setFrame:CGRectMake((column * albumSize) + xOffset, (row * albumSize) + yOffset, albumSize, albumSize)];
		eachAlbum.contents = nil;

		[self performSelectorOnMainThread:@selector(addAlbum:) withObject:eachAlbum waitUntilDone:NO];
		
		column++;
		if (column == columns) {
			column = 0;
			row--;
		}
	}
	
	if (![self isCancelled]) {
		for (CWAlbum *eachAlbum in visibleAlbums) {
			[loadArtworkOperationQueue addOperation:[[CWLoadArtworkThumbnailOperation alloc] initWithAlbum:eachAlbum size:CGSizeMake(albumSize, albumSize)]];
		}	
	}
	
	[loadArtworkOperationQueue waitUntilAllOperationsAreFinished];
	
	NSLog(@"finished update");
}

@end
