//
//  AppDelegate.m
//  SignInFromApple
//
//  Created by grx on 2020/3/17.
//  Copyright © 2020 ruixiao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *NC = [[UINavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = NC;
    return YES;
}




@end
