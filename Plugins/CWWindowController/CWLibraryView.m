//
//  CWLibraryView.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWLibraryView.h"
#import "CWLibrary.h"
#import "CWAlbum.h"
#import "CWReloadLibraryOperation.h"
#import "CWUpdateLibraryOperation.h"
#import "CWTrack.h"


@implementation CWLibraryView

+ (void)calculateRows:(NSUInteger *)rowsPointer columns:(NSUInteger *)columnsPointer albumSize:(NSUInteger *)albumSizePointer forAlbumCount:(NSUInteger)albumsCount inBounds:(NSRect)bounds {
	CGFloat area = bounds.size.width * bounds.size.height;
	CGFloat albumArea = area / albumsCount;
	NSUInteger albumSize = (NSUInteger) sqrt(albumArea);
	NSUInteger columns = floor(bounds.size.width / albumSize);
	NSUInteger rows = floor(bounds.size.height / albumSize);
	
	while ((rows * columns) < albumsCount) {
		albumSize--;
		columns = floor(bounds.size.width / albumSize);
		rows = floor(bounds.size.height / albumSize);
	}
	
	if (((rows - 1) * columns) >= albumsCount) {
		rows--;
	}

	if ((rows * (columns - 1)) >= albumsCount) {
		columns--;
	}
	
	*rowsPointer = rows;
	*columnsPointer = columns;
	*albumSizePointer = albumSize;
}

- (CWLibrary *)library {
	if (!library) {		
		library = [CWLibrary sharedInstance];
		self.wantsLayer = YES;
		self.layer = library;
		library.delegate = self;
		NSRect frame = [self frame];
		self.library.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
		[library setNeedsDisplay];
	}
	return library;
}

- (NSArray *)visibleAlbums {
	NSArray *visibleAlbums = [library.albums filteredArrayUsingPredicate:self.albumFilter];
	NSSortDescriptor *artistNameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"artist.name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
	NSSortDescriptor *albumNameSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
	visibleAlbums = [visibleAlbums sortedArrayUsingDescriptors:[NSArray arrayWithObjects:artistNameSortDescriptor, albumNameSortDescriptor, nil]];
	return visibleAlbums;
}

- (NSPredicate *)albumFilter {
	if (!albumFilter) {
		albumFilter = [NSPredicate predicateWithFormat:@"contents != NULL"];
	}
	return albumFilter;
}

- (void)cancelOperations {
	if (updateLibraryOperation) {
		[updateLibraryOperation removeObserver:self forKeyPath:@"isFinished"];
		[updateLibraryOperation cancel];
		[updateLibraryOperation release];
		updateLibraryOperation = nil;
	}
	
	if (reloadLibraryOperation) {
		[reloadLibraryOperation removeObserver:self forKeyPath:@"isFinished"];
		[reloadLibraryOperation cancel];
		[reloadLibraryOperation release];
		reloadLibraryOperation = nil;
	}
	[library clearLayer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == updateLibraryOperation) {
		[updateLibraryOperation removeObserver:self forKeyPath:@"isFinished"];
		[updateLibraryOperation release];
		updateLibraryOperation = nil;
	} else if (object == reloadLibraryOperation) {
		[reloadLibraryOperation removeObserver:self forKeyPath:@"isFinished"];
		[reloadLibraryOperation release];
		reloadLibraryOperation = nil;
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
}

- (void)reload {
	[self cancelOperations];
	
	reloadLibraryOperation = [[CWReloadLibraryOperation alloc] initWithLibrary:self.library];
	[reloadLibraryOperation addObserver:self forKeyPath:@"isFinished" options:0 context:NULL];
	[reloadLibraryOperation performSelectorInBackground:@selector(start) withObject:nil];
}

- (void)update {
	[self cancelOperations];
	
	updateLibraryOperation = [[CWUpdateLibraryOperation alloc] initWithLibrary:self.library];
	[updateLibraryOperation addObserver:self forKeyPath:@"isFinished" options:0 context:NULL];
	[updateLibraryOperation performSelectorInBackground:@selector(start) withObject:nil];	
}

- (void)mouseUp:(NSEvent *)theEvent {
	NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	CALayer *hit = [library hitTest:CGPointMake(p.x, p.y)];
	if ([hit isKindOfClass:[CWAlbum class]]) {
		CWAlbum *album = (id) hit;
		CWTrack *track = [album.tracks objectAtIndex:0];

		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
		album.zPosition = zPosition++;
		[CATransaction commit];
		
		CGRect frame = album.bounds;
		CGFloat xPoint = CGRectGetMidX(frame);
		CGFloat yPoint = CGRectGetMidY(frame);
		CATransform3D transform = CATransform3DIdentity;
		transform = CATransform3DTranslate(transform, xPoint, yPoint, 0);
		transform = CATransform3DScale(transform, 1.5, 1.5, 1.0);
		transform = CATransform3DTranslate(transform, -xPoint, -yPoint, 0);
		CABasicAnimation *clickedAnimationTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
		clickedAnimationTransform.toValue = [NSValue valueWithCATransform3D:transform];
		clickedAnimationTransform.duration = 0.25;
		clickedAnimationTransform.autoreverses = YES;
		[album addAnimation:clickedAnimationTransform forKey:@"clickedAnimationTransform"];
		
		[[NSWorkspace sharedWorkspace] openFile:[[NSURL URLWithString:track.location] path] withApplication:@"iTunes.app" andDeactivate:NO];
	}
}

- (void)cancelOperation:(id)sender {
	[NSApp terminate:nil];
}

- (BOOL)saveAsImage:(NSString *)path size:(NSSize)imageSize error:(NSError **)error {
	BOOL recreateArtwork = CGSizeEqualToSize(library.bounds.size, CGSizeMake(imageSize.width, imageSize.height));
	NSArray *visibleAlbums = [self visibleAlbums];
	NSUInteger rows;
	NSUInteger columns;
	NSUInteger albumSize;
	NSRect bounds = NSMakeRect(0, 0, imageSize.width, imageSize.height);
	
	[CWLibraryView calculateRows:&rows columns:&columns albumSize:&albumSize forAlbumCount:[visibleAlbums count] inBounds:bounds];

	imageSize = NSMakeSize(columns * albumSize, rows * albumSize);
	
	NSImage *image = [[NSImage alloc] initWithSize:imageSize];
	NSUInteger row = rows - 1;
	NSUInteger column = 0;

	[image lockFocus];
	
	CGContextRef contextRef = [[NSGraphicsContext currentContext] graphicsPort];
	
	for (CWAlbum *eachAlbum in visibleAlbums) {
		if (recreateArtwork) {
			CGImageRef artworkImageRef = [eachAlbum createAlbumArtwork:CGSizeMake(albumSize, albumSize)];
			if (artworkImageRef) {
				CGRect albumRect = CGRectMake(column * albumSize, row * albumSize, albumSize, albumSize);
				CGContextDrawImage(contextRef, albumRect, artworkImageRef);
				CFRelease(artworkImageRef);
			}
		} else {
			CGImageRef artworkImageRef = (CGImageRef) eachAlbum.contents;
			if (artworkImageRef) {
				CGRect albumRect = CGRectMake(column * albumSize, row * albumSize, albumSize, albumSize);
				CGContextDrawImage(contextRef, albumRect, artworkImageRef);
			}
		}		
				
		column++;
		if (column == columns) {
			column = 0;
			row--;
		}
	}
	
	[image unlockFocus];
	
	if (![[image TIFFRepresentation] writeToFile:path options:0 error:error]) {
		return NO;
	}
	
	return YES;
}


/*
- (void)performBackgroundReload {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSInteger scatterSize = 128;
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:(id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform, (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent, [NSNumber numberWithInteger:scatterSize], (id)kCGImageSourceThumbnailMaxPixelSize, nil];
	
	
	[library reload];
	
	// 1 schedule initial loads, scatter position randomly as loaded.
	
	NSInteger maxX = library.bounds.size.width;
	NSInteger maxY = library.bounds.size.height;

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
		
		eachAlbum.bounds = CGRectMake(0, 0, scatterSize, scatterSize);		
		eachAlbum.position = CGPointMake(x, y);
		[library addSublayer:eachAlbum];
		CWAlbumArtworkLoadOperation *eachAlbumArtworkLoadOperation = [[CWAlbumArtworkLoadOperation alloc] initWithAlbum:eachAlbum options:options];
		[eachAlbumArtworkLoadOperation release];
	}
	
	// 2. wait for initial load queue to empty
	
	// 3. apply final layout to albums that pass filter.
	
	// 4. schedule new load if new layout requires larger sized artwork.	
	
	[pool release];
}
*/
- (void)drawRect:(NSRect)aRect {
	[[NSColor blackColor] set];
	NSRectFill(aRect);
}

#pragma mark Layer Delegate

/*
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey :(NSString *)key;
- (void)displayLayer:(CALayer *)layer;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
*/

@end
