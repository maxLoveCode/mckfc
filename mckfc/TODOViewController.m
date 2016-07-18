//
//  TODOViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
#import "WorkRecordViewController.h"
#import "WorkRecordCell.h"
#import "WorkDetailViewController.h"

#import "ServerManager.h"

#import "workRecord.h"
#import "TODOViewController.h"

extern NSString *const reuseIdentifier;

@interface TODOViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;


@property (strong, nonatomic) ServerManager* server;

@property (nonatomic, strong) NSArray* recordArray;
@end


@implementation TODOViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    self.title = @"今日待办";
    
    _server = [ServerManager sharedInstance];
    if(!_recordArray)
    {
        [self requestList];
    }
}

#pragma mark setter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        NSString *const reuseIdentifier = @"workRecord";
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

#pragma mark UITableview controller
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_recordArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkRecordCell *cell = [[WorkRecordCell alloc] init];
    cell.record = _recordArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark heights;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WorkRecordCell HeightForWorkRecordCell];
}

#pragma mark selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[WorkRecordCell class]]) {
        WorkDetailViewController* detail = [[WorkDetailViewController alloc] init];
        workRecord* record = _recordArray[indexPath.row];
        [detail setTransportid: [NSString stringWithFormat:@"%@",record.recordid]];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark web request
-(void)requestList
{
    NSDictionary* params = @{@"token":_server.accessToken};
    [_server GET:@"getOrderList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSError* error;
        NSArray* data = responseObject[@"data"];
        _recordArray = [MTLJSONAdapter modelsOfClass:[workRecord class] fromJSONArray:data error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


@end
