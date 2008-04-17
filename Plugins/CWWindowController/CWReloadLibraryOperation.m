//
//  CWReloadLibraryOperation.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWReloadLibraryOperation.h"
#import "CWLibrary.h"
#import "CWAlbum.h"
#import "CWLoadArtworkThumbnailOperation.h"


@implementation CWReloadLibraryOperation

- (id)initWithLibrary:(CWLibrary *)aLibrary {
	[super init];
	library = [aLibrary retain];
	loadArtworkOperationQueue = [[NSOperationQueue alloc] init];
	return self;
}

- (void)cancel {
	[super cancel];
	[loadArtworkOperationQueue cancelAllOperations];
}

- (void)initLayers {
	NSInteger scatterSize = 32;
	NSInteger maxX = library.bounds.size.width;
	NSInteger maxY = library.bounds.size.height;

	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
	
	for (CWAlbum *eachAlbum in library.albums) {
		CGFloat x = (CGFloat)(random() % maxX);
		CGFloat y = (CGFloat)(random() % maxY);
		
		if (x < (scatterSize / 2)) {
			x = (scatterSize / 2);
		} else if (x > maxX - (scatterSize / 2)) {
			x = maxX - (scatterSize / 2);
		}
		
		if (y < (scatterSize / 2)) {
			y = (scatterSize / 2);
		} else if (y > maxY - (scatterSize / 2)) {
			y = maxY - (scatterSize / 2);
		}
		
		eachAlbum.frame = CGRectMake(x, y, scatterSize, scatterSize);		
		[library addSublayer:eachAlbum];
	}
	
	[CATransaction commit];	
}

- (void)main {
	[library reload];
	
//	[self performSelectorOnMainThread:@selector(initLayers) withObject:nil waitUntilDone:YES];
	
	if (![self isCancelled]) {
		for (CWAlbum *eachAlbum in library.albums) {
			[loadArtworkOperationQueue addOperation:[[CWLoadArtworkThumbnailOperation alloc] initWithAlbum:eachAlbum size:CGSizeMake(32, 32)]];
		}
	}

	[loadArtworkOperationQueue waitUntilAllOperationsAreFinished];

	NSLog(@"finished reload");
}

@end
