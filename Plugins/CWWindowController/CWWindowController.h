//
//  CWWindowController.h
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import <Carbon/Carbon.h>
#import <Quartz/Quartz.h>


@class CWLibraryView;

@interface CWWindowController : NSWindowController {
	IBOutlet IKImageBrowserView *coverBrowser;
	IBOutlet CWLibraryView *libraryView;
	IBOutlet NSView *accessoryView;
}

#pragma mark Class Methods

+ (id)sharedInstance;
	
- (IBAction)saveDocument:(id)sender;

@end

APPKIT_EXTERN NSString *CWExportImageFormat;
APPKIT_EXTERN NSString *CWExportImageWidth;
APPKIT_EXTERN NSString *CWExportImageHeight;
