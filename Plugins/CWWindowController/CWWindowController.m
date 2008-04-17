//
//  CWWindowController.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWWindowController.h"
#import "CWLibraryView.h"
#import "CWLibrary.h"


@implementation CWWindowController

#pragma mark Class Methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

+ (void)initialize {
	NSRect frame = [[NSScreen mainScreen] frame];
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
															 [NSNumber numberWithInteger:frame.size.width], CWExportImageWidth,
															 [NSNumber numberWithInteger:frame.size.width], CWExportImageHeight,
															 nil]];
}

#pragma mark Init

- (id)init {
	if (self = [super initWithWindowNibName:@"CWWindow"]) {
	}
	return self;
}

- (void)windowDidLoad {
//	[libraryView enterFullScreenMode:[NSScreen mainScreen] withOptions:[NSDictionary dictionary]];
	[libraryView.library reload];
	
	[coverBrowser setCellsStyleMask:IKCellsStyleNone];
	[coverBrowser setValue:[NSColor blackColor] forKey:IKImageBrowserBackgroundColorKey];
	[coverBrowser setValue:[NSColor greenColor] forKey:IKImageBrowserCellsOutlineColorKey];
	
	[coverBrowser setCellSize:NSMakeSize(64, 64)];
	[coverBrowser setConstrainsToOriginalSize:YES];

	id layoutManager = [coverBrowser valueForKey:@"layoutManager"];
	//	[layoutManager setValue:[NSNumber numberWithBool:YES] forKey:@"automaticallyMinimizeRowMargin"];
	[layoutManager setValue:[NSValue valueWithSize:NSMakeSize(0, 0)] forKey:@"margin"];
	[layoutManager setValue:[NSValue valueWithSize:NSMakeSize(0, 0)] forKey:@"cellMargin"];
	[layoutManager setValue:[NSNumber numberWithInt:NSRightTextAlignment] forKey:@"alignment"];
	
	[coverBrowser reloadData];
//	[libraryView reload];	
}

#pragma mark Actions

- (IBAction)reload:(id)sender {
	[libraryView reload];	
}

- (IBAction)update:(id)sender {
	[libraryView update];	
}

- (IBAction)saveDocument:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setTitle:BLocalizedString(@"Export as Image", nil)];
	[savePanel setRequiredFileType:@"tiff"];
	[savePanel setAccessoryView:accessoryView];
	
	if ([savePanel runModal] == NSOKButton) {
		NSSize exportSize = NSMakeSize([userDefaults integerForKey:CWExportImageWidth], [userDefaults integerForKey:CWExportImageHeight]);
		NSError *error = nil;
		
		if (![libraryView saveAsImage:[savePanel filename] size:exportSize error:&error]) {
			if (error) {
				[self presentError:error];
			}
		}
	}
}
/*
- (void)showWindow:(id)sender {
	NSScreen *screen = [[self window] screen];
	[[self window] setFrame:[screen frame] display:NO];
		
	float red, green, blue = 0;
		
	[[[NSColor blackColor] colorUsingColorSpaceName:NSDeviceRGBColorSpace] getRed:&red green:&green blue:&blue alpha:nil];
		
	CGDisplayFadeReservationToken reservationToken;
	CGAcquireDisplayFadeReservation(kCGMaxDisplayReservationInterval, &reservationToken);
	CGDisplayFade(reservationToken, 0.3, kCGDisplayBlendNormal, kCGDisplayBlendSolidColor, red, green, blue, true);
	SetSystemUIMode(kUIModeAllHidden, kUIOptionAutoShowMenuBar);
	
	[super showWindow:sender];
		
	[NSApp addWindowsItem:[self window] title:@"" filename:NO];
		
	CGDisplayFade(reservationToken, 0.3, kCGDisplayBlendSolidColor, kCGDisplayBlendNormal, red, green, blue, false);
	CGReleaseDisplayFadeReservation(reservationToken);
}

- (void)close {
	float red, green, blue = 0;
	[[[NSColor blackColor] colorUsingColorSpaceName:NSDeviceRGBColorSpace] getRed:&red green:&green blue:&blue alpha:nil];

	CGDisplayFadeReservationToken reservationToken;
	CGAcquireDisplayFadeReservation(kCGMaxDisplayReservationInterval, &reservationToken);
	CGDisplayFade(reservationToken, 0.3, kCGDisplayBlendNormal, kCGDisplayBlendSolidColor, red, green, blue, true);
	SetSystemUIMode(kUIModeNormal, 0);

	[super close];

	[NSApp removeWindowsItem:[self window]];

	CGDisplayFade(reservationToken, 0.3, kCGDisplayBlendSolidColor, kCGDisplayBlendNormal, red, green, blue, false);
	CGReleaseDisplayFadeReservation(reservationToken);
}
*/

#pragma mark Browser Data Source Methods

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)aBrowser {	
	return [libraryView.library.albums count];
}

- (id)imageBrowser:(IKImageBrowserView *)aBrowser itemAtIndex:(NSUInteger)index {
	return [libraryView.library.albums objectAtIndex:index];
}

#pragma mark Lifecycle Callback

- (void)applicationWillFinishLaunching {
	[self showWindow:nil];	
}
	
@end

NSString *CWExportImageFormat = @"CWExportImageFormat";
NSString *CWExportImageWidth = @"CWExportImageWidth";
NSString *CWExportImageHeight = @"CWExportImageHeight";
