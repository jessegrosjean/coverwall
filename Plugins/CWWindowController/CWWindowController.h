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


@class CWLibrary;
@class CWAlbum;

@interface CWWindowController : NSWindowController {
	IBOutlet IKImageBrowserView *coverBrowser;
	IBOutlet NSView *accessoryView;
	
	CWLibrary *library;
	CWAlbum *selectedAlbum;
}

#pragma mark Class Methods

+ (id)sharedInstance;

@property(readonly) CWAlbum *selectedAlbum;

- (IBAction)quickLook:(id)sender;
- (IBAction)sizeToFit:(id)sender;
- (IBAction)enterFullScreenMode:(id)sender;

- (IBAction)saveDocument:(id)sender;

@end

APPKIT_EXTERN NSString *CWExportImageFormat;
APPKIT_EXTERN NSString *CWExportImageWidth;
APPKIT_EXTERN NSString *CWExportImageHeight;
APPKIT_EXTERN NSString *CWBrowserZoomValue;