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

#import "EditorNav.h"

#import "User.h"

@interface HomepageViewController ()<UserViewDelegate>

@property (nonatomic, strong) UserView* userview;
@property (nonatomic, strong) ServerManager* serverManager;
@property (nonatomic, strong) User* user;

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
    //[self requestUserInfo];
}

-(void)requestUserInfo
{
    //根据 access token 判断第一次
    if (_serverManager.accessToken) {
        NSDictionary* params = @{@"token": _serverManager.accessToken};
        [_serverManager GET:@"getUserInfo" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            _user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject[@"data"] error:nil];
            NSLog(@"user: %@",_user);
            [_userview setContentByUser:_user];
            
            if(![_user validation]){
                EditorNav* editVC = [[EditorNav alloc] init];
                [self presentViewController:editVC animated:YES completion:^{
                    
                }];
                if ([editVC onDismissed]) {
                    [editVC setOnDismissed:^{
                        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                    }];
                }
            }
                
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    else{
        LoginNav* loginVC = [[LoginNav alloc] init];
        [self presentViewController:loginVC animated:NO completion:^{
            }];
    }
}

-(void)didClickConfirm
{
    LoadingStatsViewController *loadingStats = [[LoadingStatsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:loadingStats animated:YES];
}

@end
