//
//  EENAppDelegate.m
//  TimelapseExample
//
//  Created by Miguel Cazares on 5/27/14.
//  Copyright (c) 2014 EagleEye Networks. All rights reserved.
//

#import "EENAppDelegate.h"
#import "EENLoginViewController.h"

@implementation EENAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    EENLoginViewController *loginViewController = [[EENLoginViewController alloc] init];
    self.window.rootViewController = 
        [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
