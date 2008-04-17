//
//  CWLibraryView.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@class CWLibrary;

@interface CWLibraryView : NSView {
	CWLibrary *library;
	NSPredicate *albumFilter;
	NSOperation *reloadLibraryOperation;
	NSOperation *updateLibraryOperation;
	NSInteger zPosition;
}

+ (void)calculateRows:(NSUInteger *)rowsPointer columns:(NSUInteger *)columnsPointer albumSize:(NSUInteger *)albumSizePointer forAlbumCount:(NSUInteger)albumsCount inBounds:(NSRect)bounds;

@property(readonly) CWLibrary *library;
@property(readonly) NSArray *visibleAlbums;
@property(readonly) NSPredicate *albumFilter;

- (void)reload;
- (void)update;

- (BOOL)saveAsImage:(NSString *)path size:(NSSize)imageSize error:(NSError **)error;

@end
