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

#import "JPushService.h"

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

    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    
//the usertype flag, needs to be cleared if logout
    NSString* user_type = [defaults objectForKey:@"user_type"];
    NSLog(@"user_type %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"]);
    if (user_type == nil || [user_type isEqualToString:MKUSER_TYPE_DRIVER] || [user_type isEqualToString:@""]) {
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
    
//    // Register the supported interaction types.
//    UIUserNotificationType types = UIUserNotificationTypeBadge |
//    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//    UIUserNotificationSettings *mySettings =
//    [UIUserNotificationSettings settingsForTypes:types categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//    
//    // Register for remote notifications.
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
//Jpush
    [self JPushInitailizationWithOption:launchOptions];
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

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did fail to register for remote notification");
}

- (void)JPushInitailizationWithOption:(NSDictionary*) options
{
    //Required
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
#pragma clang diagnostic pop
    }
    
    [JPUSHService setupWithOption:options
                           appKey:@"a69a0e330940d3f164a2a82d"
                          channel:nil apsForProduction:NO];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //[JPUSHService setLogOFF];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationIdScan object:self userInfo:userInfo];
    
    NSLog(@"%@", userInfo);
}


@end
