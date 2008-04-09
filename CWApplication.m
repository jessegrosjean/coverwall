//
//  CWApplication.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CWApplication.h"


@implementation CWApplication

#pragma mark BLicenseManager declareLicenses extension point callback.

- (void)declareLicenses {
	BLicense *license = [[BLicenseManagerController sharedInstance] licenseForLicenseName:@"CoverWall"];	
	[license setPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPj/0mqJi+2ipUvhshsqn/e/m0\nFpfT/bdmiZyam7RnxLKIue4KfvauycYUBlnjw4JAZlD5bYXacWJW/XWnhB/w98HV\n/Cfj8FvrBQAISPQttD7nJt4XQ7WhL5blXd4cO8cOt9Xqqsr5YRJV+LvuRhO0gogU\njtAWnzTr3U65EyvrbQIDAQAB\n-----END PUBLIC KEY-----\n"];
	[license setNumberOfTrialDays:15];
	[license setPurchaseURL:[NSURL URLWithString:@"https://hogbaysoftware.com/store"]];
	[license setRecoverLostLicenseURL:[NSURL URLWithString:@"http://hogbaysoftware.com/store/resend_licenses"]];
	[[BLicenseManagerController sharedInstance] setApplicationLicenseName:@"CoverWall"];
}

@end
