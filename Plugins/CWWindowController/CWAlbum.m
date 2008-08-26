//
//  CWAlbum.m
//  ArtTest
//
//  Created by Jesse Grosjean on 4/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWAlbum.h"
#import "CWLibrary.h"
#import "CWTrack.h"
#import <QuickLook/QuickLook.h>

@implementation CWAlbum

@synthesize name;
@synthesize sortName;
@synthesize tracks;

- (NSString *)imageUID {
	return [[tracks objectAtIndex:0] persistentID];
}

- (NSString *)imageRepresentationType {
	return IKImageBrowserPathRepresentationType;
//	return IKImageBrowserNSDataRepresentationType;
//	return IKImageBrowserQuickLookPathRepresentationType;
}

- (id)imageRepresentation {
	if (!imageRepresentation) {
		imageRepresentation = [[tracks objectAtIndex:0] artworkPath];
//		imageRepresentation = [[tracks objectAtIndex:0] artwork];
	}
	return imageRepresentation;
}

@end