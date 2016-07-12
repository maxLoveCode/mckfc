//
//  TranspotationPlanViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/21.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TranspotationPlanViewController.h"
#import "TransportationViewCell.h"
#import "MapViewController.h"
#import "QueueViewController.h"

#import "ServerManager.h"

#define itemHeight 44

@interface TranspotationPlanViewController()<mapViewDelegate>

@property (nonatomic, strong) MapViewController* mapVC;
@property (nonatomic, strong) ServerManager* server;

@property (nonatomic, strong) UIButton* confirm;


@end


@implementation TranspotationPlanViewController
{
    NSArray* titleText;
}

-(void)viewDidLoad
{
    self.title = @"运输计划";
    
    [self.tableView registerClass:[TransportationViewCell class] forCellReuseIdentifier:@"plan"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    titleText = @[@"发运时间",@"运输目的地",@"计划到达时间",@"计划卸货时间"];
    _server = [ServerManager sharedInstance];
    [self requestDetails];
}

-(MapViewController *)mapVC
{
    if (!_mapVC && _detail.pointx!= nil && _detail.pointy!=nil) {
        _mapVC = [[MapViewController alloc] initWithTerminateLong:[_detail.pointx doubleValue] Lat:[_detail.pointy doubleValue]];
        _mapVC.delegate = self;
        [self addChildViewController:_mapVC];
    }
    return _mapVC;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"我已到厂前" forState:UIControlStateNormal];
        
        [_confirm setBackgroundColor:COLOR_TEXT_GRAY];
        
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        [_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        [_confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _confirm.enabled = NO;
    }
    return _confirm;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 4) {
        
        return itemHeight;
    }
    else
        return kScreen_Height-itemHeight*6-20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 4)
    {
        TransportationViewCell* cell = [[TransportationViewCell alloc] init];
        cell.titleLabel.text = titleText[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailLabel.text = _detail.departuretime;
        }
        else if(indexPath.row == 1){
            cell.detailLabel.text = _detail.destination;
        }
        else if(indexPath.row == 2){
            cell.detailLabel.text = _detail.planarrivetime;
        }
        else if(indexPath.row == 3){
            cell.detailLabel.text = _detail.planentertime;
        }
        return cell;
    }
    else if(indexPath.row ==4)
    {
        UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"plan" forIndexPath:indexPath];
        if (_detail) {
            [self.mapVC.view setFrame:cell.contentView.frame];
            [cell.contentView addSubview:self.mapVC.view];
        }
        return cell;
    }
    else
    {
        UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"plan" forIndexPath:indexPath];
        

        [cell.contentView addSubview:self.confirm];
        [self.confirm setFrame: cell.contentView.frame];
        return cell;
    }
}

#pragma selector
-(void)confirmBtn
{
    [self.mapVC.timer fire];
}

#pragma mark loding stats
-(void)requestDetails
{
    NSDictionary* params;
    params = @{@"token":_server.accessToken,
               @"id":[NSString stringWithFormat:@"%lu",(long)_detail.transportID]};
    [_server GET:@"getTransportDetail" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        NSError* error;
        _detail = [MTLJSONAdapter modelOfClass:[TransportDetail class] fromJSONDictionary:data error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)mapView:(MapViewController *)mapView LocationOnLatitude:(double)latitude Longtitude:(double)longtitude address:(NSString *)address distance:(double)distance expecttime:(long)expecttime
{
    NSDictionary* params = @{@"transportid": [NSString stringWithFormat:@"%lu",_detail.transportID],
                             @"distance":[NSString stringWithFormat:@"%f",distance],
                             @"pointx":[NSString stringWithFormat:@"%f",longtitude],
                             @"pointy":[NSString stringWithFormat:@"%f",latitude],
                             @"address":address,
                             @"expecttime":[NSString stringWithFormat:@"%ld",expecttime],
                             @"token":_server.accessToken};
    [_server POST:@"location" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //NSLog(@"%@", responseObject);
        if ([responseObject[@"data"] objectForKey:@"isbefore"]) {
            
            [self.mapVC.timer invalidate];
            QueueViewController* queueVC = [[QueueViewController alloc] initWithID:_detail.transportID];
            [self.navigationController pushViewController:queueVC animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)mapViewhasLocated:(MapViewController *)mapView
{
    self.confirm.enabled = YES;
    [_confirm setBackgroundColor:COLOR_THEME];
}
@end
