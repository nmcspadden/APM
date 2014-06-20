//
//  APMAppDelegate.m
//  AutoPkgManager
//
//  Created by Nick McSpadden on 6/20/14.
//  Copyright (c) 2014 Schools of the Sacred Heart. All rights reserved.
//

#import "APMAppDelegate.h"

@implementation APMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //get list of recipe search dirs, and recipe repos
    NSArray* RecipeSearchDirs = (__bridge NSArray *)(CFPreferencesCopyAppValue(CFSTR("RECIPE_SEARCH_DIRS"), CFSTR("com.github.autopkg")));
    NSDictionary* RecipeRepos = (__bridge NSDictionary *)(CFPreferencesCopyAppValue(CFSTR("RECIPE_REPOS"), CFSTR("com.github.autopkg")));
    //get list of default processors by looking in /Library/AutoPkg/autopkglib for things ending in .py and not starting with __init__
    
}

@end
