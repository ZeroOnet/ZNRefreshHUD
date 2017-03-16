//
//  AppDelegate.m
//  ZNRefreshHUD
//
//  Created by FunctionMaker on 2017/3/8.
//  Copyright © 2017年 FunctionMaker. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    
    _window.rootViewController = navC;
    
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
