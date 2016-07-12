//
//  QueueViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/21.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QueueViewController.h"
#import "QRCodeView.h"

#import "ReportViewController.h"
#import "ServerManager.h"

#import "UIImageView+WebCache.h"

#define itemHeight 44
#define topMargin 60

@interface QueueViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* titleText;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) QRCodeView* QRCode;
@property (nonatomic, strong) ServerManager* server;

@property (nonatomic, assign) NSInteger transportID;

@end

@implementation QueueViewController

-(instancetype)initWithID:(NSInteger)transportID
{
    self = [super init];
    self.transportID = transportID;
    return self;
}

-(void)viewDidLoad
{
    titleText = @[@"预计厂前等待时间：",@"仓库位置："];
    self.view = self.tableView;
    
    _server = [ServerManager sharedInstance];
    [self requestQRCode];
}

#pragma mark setter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Queue"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(QRCodeView *)QRCode
{
    if (!_QRCode) {
        _QRCode = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, 288, 288)];
        [_QRCode setCenter:CGPointMake(kScreen_Width/2, itemHeight+topMargin+144)];
    }
    return _QRCode;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return itemHeight;
    }
    else
        return kScreen_Height-64-itemHeight*4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Queue" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44+k_Margin, 0, 150, itemHeight)];
        titleLabel.text = titleText[indexPath.row];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = COLOR_TEXT_GRAY;
        [cell.contentView addSubview:titleLabel];
        return cell;
    }
    else
    {
        UILabel* label =[[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-k_Margin*2, itemHeight*2)];
        label.text = @"卸货时请出示下列二维码，收货人员可快速验收货物信息，提高您的卸货速度";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = COLOR_TEXT_GRAY;
        label.numberOfLines = 2;
        [cell.contentView addSubview:label];
        
        [cell.contentView addSubview:self.QRCode];
        return cell;
    }
}

#pragma mark tableview header and footers
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section ==0)
    {
        return itemHeight;
    }
    else
        return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section ==0)
    {
        return itemHeight;
    }
    else
        return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        return view;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight)];
        [view setBackgroundColor:[UIColor whiteColor]];
        return view;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self generateReport];
}

-(void)generateReport
{
    ReportViewController* reportVC = [[ReportViewController alloc] init];
    [self.navigationController pushViewController:reportVC animated:YES];
}

-(void)requestQRCode
{
    [self.QRCode setQRCode:@"test"];
}

-(void)requestQueueInfo
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"id":[NSString stringWithFormat:@"%lu",_transportID]};
    [_server GET:@"getQueueDetail" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"response:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
 
@end
