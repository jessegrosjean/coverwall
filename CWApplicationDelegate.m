//
//  CWApplicationDelegate.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWApplicationDelegate.h"


@implementation CWApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	BLicense *license = [[BLicenseManagerController sharedInstance] licenseForLicenseName:@"CoverWall"];
	
	if (![license isValid]) {
		if ([license trialDaysRemaining] > 0) {
			[license runShowTrialAlert];
		} else if (![license runShowTrailExpiredAlert]) {
			[NSApp terminate:self];
		}
	}
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
	return [[NSDocumentController sharedDocumentController] applicationShouldOpenUntitledFile:sender];
}

#pragma mark Help Actions

- (IBAction)openApplicationHelp:(id)sender {	
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://hogbaysoftware.com/products/coverwall/user_guide"]];	
}

- (IBAction)openApplicationWebPage:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://hogbaysoftware.com/products/coverwall"]];
}
- (IBAction)openApplicationUserForums:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://hogbaysoftware.com/forums/coverwall"]];
}

- (IBAction)openApplicationReleaseNotes:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://hogbaysoftware.com/products/coverwall/releases"]];	
}

- (IBAction)openApplicationAcknowledgments:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://hogbaysoftware.com/products/hog_bay_software/pages/acknowledgments"]];	
}

@end
