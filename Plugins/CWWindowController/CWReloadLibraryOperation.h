//
//  CWReloadLibraryOperation.h
//  ArtTest
//
//  Created by Jesse Grosjean on 4/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@class CWLibrary;

@interface CWReloadLibraryOperation : NSOperation {
	CWLibrary *library;
	NSOperationQueue *loadArtworkOperationQueue;
}

- (id)initWithLibrary:(CWLibrary *)aLibrary;

@end
