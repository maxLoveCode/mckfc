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
#import "LoadingStatsViewController.h"

@interface HomepageViewController ()<UserViewDelegate>

@property (nonatomic, strong) UserView* userview;
@property (nonatomic, strong) ServerManager* serverManager;

@end

@implementation HomepageViewController

-(void)viewDidLoad
{
    self.title = @"首页";
    _userview = [[UserView alloc] init];
    _serverManager = [ServerManager sharedInstance];
    
    _userview.delegate = self;
    
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

-(void)didClickConfirm
{
    LoadingStatsViewController *loadingStats = [[LoadingStatsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:loadingStats animated:YES];
}

@end
