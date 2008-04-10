//
//  CWWindowController.h
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>


@class CWWall;
@class CWView;

@interface CWWindowController : NSWindowController {
	IBOutlet CWView *wallView;
	IBOutlet NSTextField *statusTextField;
	
	CWWall *wall;
	NSError *processingError;
}

#pragma mark Class Methods

+ (id)sharedInstance;
	
@end
