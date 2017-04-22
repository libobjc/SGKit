//
//  AppDelegate.m
//  demo
//
//  Created by Single on 2017/4/22.
//  Copyright © 2017年 Single. All rights reserved.
//

#import "AppDelegate.h"
#import "Example.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[Example alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
