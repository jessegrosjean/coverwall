//
//  CWArtist.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface CWArtist : NSObject {
	NSString *name;
	NSString *sortName;
	NSMutableArray *albums;
}

@property(readonly) NSString *name;
@property(readonly) NSString *sortName;
@property(readonly) NSArray *albums;

@end
