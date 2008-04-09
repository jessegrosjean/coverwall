//
//  main.m
//  CoverWall
//
//  Created by Jesse Grosjean on 4/8/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>


int main(int argc, char *argv[]) {
	[[BExtensionRegistry sharedInstance] loadMainExtension];
	
    return NSApplicationMain(argc,  (const char **) argv);
}
