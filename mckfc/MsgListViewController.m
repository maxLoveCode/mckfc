//
//  MsgListViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/27.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "MsgListViewController.h"
#import "ServerManager.h"

@interface MsgListViewController ()

@property (strong, nonatomic) ServerManager* server;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation MsgListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _server =[ServerManager sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestList];
}

-(void)requestList
{
    [_server GET:@"getMessageList" parameters:@{@"token":_server.accessToken} animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
