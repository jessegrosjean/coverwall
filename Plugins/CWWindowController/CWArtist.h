//
//  CWArtist.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface CWArtist : CALayer {
	NSMutableArray *albums;
}

@property(readonly) NSArray *albums;

@end
