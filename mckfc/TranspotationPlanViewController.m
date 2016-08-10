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
#import "rightNavigationItem.h"

#import "ServerManager.h"
#import "AlertHUDView.h"

#define itemHeight 44

@interface TranspotationPlanViewController()<mapViewDelegate,menuDelegate,HUDViewDelegate>

@property (nonatomic, strong) MapViewController* mapVC;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) rightNavigationItem* popUpMenu;
@property (nonatomic, strong) AlertHUDView* alert;
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
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = self.popUpMenu;
    
    titleText = @[@"发运时间",@"运输目的地",@"计划到达时间",@"计划入场时间"];
    _server = [ServerManager sharedInstance];
    [self requestDetails];
    BOOL prompt = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationPrompt"];
    if(!prompt)
    {
        [self locationServicePrompt];
    }
}

#pragma mark - setter properties
-(AlertHUDView *)alert
{
    if (!_alert) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.delegate = self;
    }
    return _alert;
}

-(MapViewController *)mapVC
{
    if (!_mapVC && _detail.pointx!= nil && _detail.pointy!=nil) {
        _mapVC = [[MapViewController alloc] initWithTerminateLong:[_detail.pointx doubleValue] Lat:[_detail.pointy doubleValue]];
        _mapVC.locationTime = [_detail.autoLocationTime floatValue];
        _mapVC.delegate = self;
        [self addChildViewController:_mapVC];
    }
    return _mapVC;
}

-(rightNavigationItem *)popUpMenu
{
    if (!_popUpMenu) {
        _popUpMenu = [[rightNavigationItem alloc] initCutomItem];
        _popUpMenu.delegate =self;
    }
    return _popUpMenu;
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
            UIFont* font = cell.detailLabel.font;
            NSDictionary* attribute = @{NSFontAttributeName:font};
            const CGSize textSize = [cell.detailLabel.text sizeWithAttributes: attribute];
                if (textSize.width > cell.detailTextLabel.frame.size.width) {
                    cell.detailLabel.font = [UIFont systemFontOfSize:12];
                    cell.detailLabel.numberOfLines = 2;
            }
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
    NSLog(@"%@", params);
    [_server GET:@"getTransportDetail" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        NSLog(@"data: %@", data);
        NSError* error;
        NSInteger transportID = _detail.transportID;
        _detail = [MTLJSONAdapter modelOfClass:[TransportDetail class] fromJSONDictionary:data error:&error];
        _detail.transportID = transportID;
        if (error) {
            NSLog(@"error %@", error);
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)mapView:(MapViewController *)mapView LocationOnLatitude:(double)latitude Longtitude:(double)longtitude address:(NSString *)address distance:(double)distance expecttime:(long)expecttime
{
    NSDictionary* params = @{@"transportid": [NSString stringWithFormat:@"%lu",(long)_detail.transportID],
                             @"pointx":[NSString stringWithFormat:@"%f",longtitude],
                             @"pointy":[NSString stringWithFormat:@"%f",latitude],
                             @"expecttime":[NSString stringWithFormat:@"%ld",expecttime],
                             @"token":_server.accessToken};
    [_server POST:@"location" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([[responseObject[@"data"] objectForKey:@"isbefore"] integerValue] == 1) {
            [self.mapVC.timer invalidate];
            [self.popUpMenu dismiss];
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

#pragma mark right menu delegate
-(void)MenuView:(rightNavigationItem *)Menu selectIndexPath:(NSIndexPath *)indexPath
{
    [_popUpMenu dismiss];
    if (indexPath.row == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"取消运输计划" message:@"你确定要取消运输计划吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认取消" style:
                         UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             [self cancelTransport];
                         }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        //phone call
        NSString* phone = _detail.factoryphone;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
    }
}

-(void)cancelTransport
{
    NSDictionary* params;
    params = @{@"token": _server.accessToken,
               @"transportid":[NSString stringWithFormat:@"%lu",(long)_detail.transportID]};
    [_server POST:@"cancelTransport" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self.mapVC.timer invalidate];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark -alertview delegate
-(void)didSelectConfirm
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"locationPrompt"];
    [self.alert removeFromSuperview];
}

-(void)locationServicePrompt
{
    self.alert.title.text = @"使用位置信息";
    self.alert.detail.text = @"我们将在后台关注你的位置消息用来监管";
    self.alert.detail.numberOfLines = 0;
    [self.alert show:_alert];
}
@end
