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
	[license setPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCxNotplHyWFiNrmGBvVwwxZspd\nKfk01g9t8c+UQt39FW3ZsQZv79xbxOhbv419JMEy+J9oeb02vgIBK0Gu3T2JzSdE\nfoCerjmW4OSH4wG/o/cq2MPzbupJ1Uy6EkM5Bq9ZdGBjN2K2HSONmxtZd9w6jW3x\ntghzAlJgWCxD4rVm9wIDAQAB\n-----END PUBLIC KEY-----\n"];
	[license setNumberOfTrialDays:30];
	[license setPurchaseURL:[NSURL URLWithString:@"https://hogbaysoftware.com/store"]];
	[license setRecoverLostLicenseURL:[NSURL URLWithString:@"http://hogbaysoftware.com/store/resend_licenses"]];
	[[BLicenseManagerController sharedInstance] setApplicationLicenseName:@"CoverWall"];
}

@end
