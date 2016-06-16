//
//  HomepageViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "HomepageViewController.h"
#import "UserView.h"
#import "ServerManager.h"
#import "LoginNav.h"

@interface HomepageViewController ()

@property (nonatomic, strong) UserView* userview;
@property (nonatomic, strong) ServerManager* serverManager;

@end

@implementation HomepageViewController

-(void)viewDidLoad
{
    _userview = [[UserView alloc] init];
    _serverManager = [ServerManager sharedInstance];
    
    self.view = _userview;
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!_serverManager.accessToken) {
        LoginNav* loginVC = [[LoginNav alloc] init];
        [self presentViewController:loginVC animated:NO completion:^{
            
        }];
    }
}

-(void)requestUserInfo
{
    
}

@end
