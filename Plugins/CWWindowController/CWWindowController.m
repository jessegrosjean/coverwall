//
//  CWWindowController.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWWindowController.h"
#import "CWWall.h"
#import "CWView.h"


@implementation CWWindowController

#pragma mark Class Methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark Init

- (id)init {
	if (self = [super initWithWindowNibName:@"CWWindow"]) {
	}
	return self;
}

#pragma mark Actions

- (IBAction)refreshWall:(id)sender {
	wall = [[CWWall alloc] init];
//	wall.targetSize = [[NSScreen mainScreen] frame].size;
//	[wall performSelectorInBackground:@selector(processWallWithDelegate:) withObject:self];
}

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
	
	[self refreshWall:nil];
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

#pragma mark Wall Delegate

- (void)wallWillBeginProcessing:(CWWall *)aWall {
	[wallView performSelectorOnMainThread:@selector(setWallImage:) withObject:[[NSImage alloc] initWithSize:aWall.actualSize] waitUntilDone:YES];
}

- (void)wall:(CWWall *)aWall processTrack:(iTunesTrack *)track {
	NSString *trackName = [track name];
	[statusTextField performSelectorOnMainThread:@selector(setStringValue:) withObject:trackName waitUntilDone:NO];
	
	iTunesArtwork *trackArtwork = [[track artworks] objectAtIndex:0];
	NSImage *trackArtworkImage = [trackArtwork data];
	if (!processingError) { 
		NSSize trackArtworkSize = [trackArtworkImage size];	
		NSRect fromRect = NSMakeRect(0, 0, trackArtworkSize.width, trackArtworkSize.height);
		NSRect trackRect = [aWall rectForTrack:track];
		NSImage *wallImage = wallView.wallImage;
		[wallImage lockFocus];
		[trackArtworkImage drawInRect:trackRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1.0];
		[wallImage unlockFocus];
		[wallView setNeedsDisplayInRect:[wallView convertWallImageRectToViewRect:trackRect]];
	}
	processingError = nil;
}

- (void)wall:(CWWall *)aWall error:(NSError *)error processingTrack:(iTunesTrack *)track {
	processingError = error;
}

- (void)wallWillEndProcessing:(CWWall *)aWall {
	[statusTextField performSelectorOnMainThread:@selector(setStringValue:) withObject:@"" waitUntilDone:NO];
	[[[self window] contentView] setNeedsDisplay:YES];
}

#pragma mark Lifecycle Callback

- (void)applicationWillFinishLaunching {
	[self showWindow:nil];	
}
	
@end
