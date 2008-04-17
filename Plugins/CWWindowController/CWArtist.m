//
//  CWArtist.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWArtist.h"
#import "CWLibrary.h"

@implementation CWArtist

- (void)dealloc {
	[albums release];
	[super dealloc];
}

@synthesize albums;

@end