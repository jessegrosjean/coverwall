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
#import "CWAlbum.h"
#import "QuickLook.h"


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
															 [NSNumber numberWithFloat:0], CWBrowserZoomValue,
															 nil]];
}

#pragma mark Init

- (id)init {
	if (self = [super initWithWindowNibName:@"CWWindow"]) {
	}
	return self;
}

- (void)windowDidLoad {
	[[self window] setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[[self window] setContentBorderThickness:37 forEdge:NSMinYEdge];

//	[libraryView enterFullScreenMode:[NSScreen mainScreen] withOptions:[NSDictionary dictionary]];
	library = [CWLibrary sharedInstance];
	
	[coverBrowser setCellsStyleMask:IKCellsStyleNone];
	[coverBrowser setValue:[NSColor blackColor] forKey:IKImageBrowserBackgroundColorKey];
	[coverBrowser setValue:[NSColor greenColor] forKey:IKImageBrowserCellsOutlineColorKey];
	
//	[coverBrowser setCellSize:NSMakeSize(64, 64)];
//	[coverBrowser setConstrainsToOriginalSize:YES];

	id layoutManager = [coverBrowser valueForKey:@"layoutManager"];
	//	[layoutManager setValue:[NSNumber numberWithBool:YES] forKey:@"automaticallyMinimizeRowMargin"];
	[layoutManager setValue:[NSValue valueWithSize:NSMakeSize(0, 0)] forKey:@"margin"];
	[layoutManager setValue:[NSValue valueWithSize:NSMakeSize(0, 0)] forKey:@"cellMargin"];
	[layoutManager setValue:[NSNumber numberWithInt:NSRightTextAlignment] forKey:@"alignment"];	
}

- (CWAlbum *)selectedAlbum {
	return selectedAlbum;
}

#pragma mark Actions

- (IBAction)reload:(id)sender {
	[library reload];
	[coverBrowser reloadData];
}

- (IBAction)update:(id)sender {
	[coverBrowser reloadData];
}

#define QLPreviewPanel NSClassFromString(@"QLPreviewPanel")

- (IBAction)quickLook:(id)sender {
	if (selectedAlbum != nil && [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/QuickLookUI.framework"] load]) {
		[[[QLPreviewPanel sharedPreviewPanel] windowController] setDelegate:self];
		[[QLPreviewPanel sharedPreviewPanel] setURLs:[NSArray arrayWithObject:[selectedAlbum imageRepresentation]] currentIndex:0 preservingDisplayState:YES];
		[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFrontWithEffect:2];
	}
}

- (NSRect)previewPanel:(NSPanel*)panel frameForURL:(NSURL*)URL {
	NSRect frame = [coverBrowser itemFrameAtIndex:[[coverBrowser selectionIndexes] firstIndex]];
	frame = [coverBrowser convertRect:frame toView:nil];
	frame.origin = [[coverBrowser window] convertBaseToScreen:frame.origin];
	frame.origin.y -= frame.size.height;
	return frame;
}

- (IBAction)sizeToFit:(id)sender {
	NSUInteger albumCount = [library.albums count];
	if (albumCount == 0)
		return;
	
	NSRect bounds = [coverBrowser visibleRect];
	CGFloat area = bounds.size.width * bounds.size.height;
	CGFloat albumArea = area / albumCount;
	NSUInteger albumSize = (NSUInteger) sqrt(albumArea);
	NSUInteger columns = floor(bounds.size.width / albumSize);
	NSUInteger rows = floor(bounds.size.height / albumSize);
	
	while ((rows * columns) < albumCount) {
		albumSize--;
		columns = floor(bounds.size.width / albumSize);
		rows = floor(bounds.size.height / albumSize);
	}
	
	if (albumSize > 512) albumSize = 512;
	if (albumSize < 32) albumSize = 32;
	
	[coverBrowser setCellSize:NSMakeSize(albumSize, albumSize)];
}

- (IBAction)enterFullScreenMode:(id)sender {
	[[coverBrowser enclosingScrollView] enterFullScreenMode:[[self window] screen] withOptions:NULL];
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
		
/*		if (![libraryView saveAsImage:[savePanel filename] size:exportSize error:&error]) {
			if (error) {
				[self presentError:error];
			}
		}*/
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
	return [library.albums count];
}

- (id)imageBrowser:(IKImageBrowserView *)aBrowser itemAtIndex:(NSUInteger)index {
	return [library.albums objectAtIndex:index];
}

#pragma mark Browser Delegate Methods

- (void)imageBrowser:(IKImageBrowserView *)aBrowser backgroundWasRightClickedWithEvent:(NSEvent *)event {
	
}

- (void)imageBrowser:(IKImageBrowserView *)aBrowser cellWasDoubleClickedAtIndex:(NSUInteger)index {
	
}

- (void)imageBrowser:(IKImageBrowserView *)aBrowser cellWasRightClickedAtIndex:(NSUInteger)index withEvent:(NSEvent *)event {
	
}

- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)aBrowser {
	[self willChangeValueForKey:@"selectedAlbum"];
	NSUInteger selectedIndex = [[aBrowser selectionIndexes] firstIndex];
	if (selectedIndex != NSNotFound) {
		selectedAlbum = [library.albums objectAtIndex:selectedIndex];
	} else {
		selectedAlbum = nil;
	}
	[self didChangeValueForKey:@"selectedAlbum"];
}

#pragma mark Window Delegate

- (void)windowDidResize:(NSNotification *)notification {
	[self sizeToFit:nil];
}

#pragma mark Lifecycle Callback

- (void)applicationWillFinishLaunching {
	[self showWindow:nil];	
}
	
@end

NSString *CWExportImageFormat = @"CWExportImageFormat";
NSString *CWExportImageWidth = @"CWExportImageWidth";
NSString *CWExportImageHeight = @"CWExportImageHeight";
NSString *CWBrowserZoomValue = @"CWBrowserZoomValue";
