//
//  AppDelegate.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/12.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadingNav.h"
#import "SecurityNav.h"
#import "QualityControlNav.h"

@interface AppDelegate ()

@property (nonatomic, strong) LoadingNav* loadingNav;
@property (nonatomic, strong) SecurityNav* securityNav;
@property (nonatomic, strong) QualityControlNav* QCNav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [UIWindow new];
    [self.window makeKeyAndVisible];
    self.window.frame = [[UIScreen mainScreen] bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];

    NSString* user_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"];
    user_type = MKUSER_TYPE_DRIVER;
    [[NSUserDefaults standardUserDefaults] setObject:user_type forKey:@"user_type"];
    
    if (!user_type || [user_type isEqualToString:MKUSER_TYPE_DRIVER] ) {
//装载导视图（default）
        self.loadingNav = [[LoadingNav alloc] init];
        self.window.rootViewController = self.loadingNav;
    }
    else if([user_type isEqualToString:MKUSER_TYPE_SECURITY]) {
        self.securityNav = [[SecurityNav alloc] init];
        self.window.rootViewController = self.securityNav;
    }
    else
    {
        self.QCNav = [[QualityControlNav alloc] init];
        self.window.rootViewController = self.QCNav;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
