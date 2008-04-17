//
//  CWLibrary.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface CWLibrary : CALayer {
	NSMutableArray *artists;
	NSMutableArray *albums;
	NSMutableArray *tracks;
	NSMutableDictionary *namesToArtists;
	NSMutableDictionary *namesToAlbums;
}

#pragma mark Class Methods

+ (id)sharedInstance;
+ (NSString *)libraryXMLPath;
	
- (id)artistWithName:(NSString *)aName;
@property(readonly) NSArray *artists;
- (id)albumWithName:(NSString *)aName;
@property(readonly) NSArray *albums;
@property(readonly) NSArray *tracks;

- (void)reload;
- (void)clearLayer;

@end
