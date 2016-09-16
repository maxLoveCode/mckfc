//
//  MsgListViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/27.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "MsgListViewController.h"
#import "ServerManager.h"
#import "Message.h"
#import "MsgTableViewCell.h"

static NSString * const kCellid = @"MsgCell";

@interface MsgListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger currentSelect;
}

@property (strong, nonatomic) ServerManager* server;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray* msgArray;

@end

@implementation MsgListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息列表";
    _server =[ServerManager sharedInstance];
    _msgArray = [[NSArray alloc] init];
    currentSelect = -1;
    self.view = self.tableView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestList];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSString* reuseid = kCellid;
        [_tableView registerClass:[MsgTableViewCell class] forCellReuseIdentifier:reuseid];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _msgArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.msgArray count] == 0) {
        return [MsgTableViewCell heightForCell];
    }
    else
    {
        if (indexPath.section == currentSelect) {
            return [self.msgArray[indexPath.section] contentHeight];
        }
        else
            return [MsgTableViewCell heightForCell];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseid = kCellid;
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid forIndexPath:indexPath];
    [cell setMessage:self.msgArray[indexPath.section]];
    if (indexPath.section == currentSelect) {
        cell.expand = YES;
    }
    else
    {
        cell.expand = NO;
    }
    return cell;
}
-(void)requestList
{
    [_server GET:@"getMessageList" parameters:@{@"token":_server.accessToken} animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //NSLog(@"%@", responseObject);
        NSArray* msgJSON = responseObject[@"data"];
        if (msgJSON) {
            NSError* error;
            _msgArray = [MTLJSONAdapter modelsOfClass:[Message class] fromJSONArray:msgJSON error:&error];
            if (error) {
                NSLog(@"error : %@", error);
            }
            else
            {
                [self.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell fullTextHeight] > 130.0f) {
        NSIndexPath* lastCell = [NSIndexPath indexPathForRow:0 inSection:currentSelect];
        MsgTableViewCell* cell = [tableView cellForRowAtIndexPath:lastCell];
        NSArray* indexArray;
        if (cell != nil) {
            indexArray = @[indexPath, lastCell];
        }
        else
        {
            indexArray = @[indexPath];
        }
        currentSelect = indexPath.section;
        [tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
