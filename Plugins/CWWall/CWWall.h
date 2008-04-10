//
//  CWWall.h
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#include <CoreServices/CoreServices.h>
#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BDocuments.h"
#import "iTunes.h"


@interface CWWall : NSObject {
	NSSize targetSize;
	NSSize actualSize;
	NSUInteger rows;
	NSUInteger columns;
	NSUInteger trackSize;
	NSMutableArray *tracks;
	NSPredicate *trackPredicate;
	iTunesApplication *iTunes;
	NSError *scriptingBridgeError;
	id currentDelegate;
	id currentTrack;
}

@property(assign) NSSize targetSize;
@property(readonly) NSSize actualSize;
@property(readonly) NSUInteger rows;
@property(readonly) NSUInteger columns;
@property(readonly) NSUInteger trackSize;
@property(readonly) NSArray *tracks;
@property(readonly) iTunesApplication *iTunes;

- (iTunesTrack *)trackAtPoint:(NSPoint)point;
- (NSRect)rectForTrack:(iTunesTrack *)track;
- (NSRect)rectForRow:(NSUInteger)aRow columns:(NSUInteger)aColumn;
- (void)processWallWithDelegate:(id)delegate;

@end

@interface NSObject (CWArtworkDelegate)
- (void)wallWillBeginProcessing:(CWWall *)wall;
- (void)wall:(CWWall *)wall processTrack:(iTunesTrack *)track;
- (void)wall:(CWWall *)wall error:(NSError *)error processingTrack:(iTunesTrack *)track;
- (void)wallWillEndProcessing:(CWWall *)wall;
@end
