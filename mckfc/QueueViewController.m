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
#import "WorkStatusView.h"

#import "queueViewModel.h"

#define itemHeight 44
#define topMargin 60

@interface QueueViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* titleText;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) QRCodeView* QRCode;
@property (nonatomic, strong) WorkStatusView* statusView;
@property (nonatomic, strong) ServerManager* server;


@property (nonatomic, assign) NSInteger transportID;
@property (nonatomic, strong) queueViewModel* viewModel;

@end

@implementation QueueViewController

-(instancetype)initWithID:(NSInteger)transportID
{
    self = [super init];
    self.transportID = transportID;
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem* phone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"service"] style:UIBarButtonItemStylePlain target:self action:@selector(phoneCall:)];
    self.navigationItem.rightBarButtonItem = phone;
    
    return self;
}

-(void)viewDidLoad
{
    self.title = @"厂前排队";
    titleText = @[@"预计厂前等待时间：",@"仓库位置："];
    self.view = self.tableView;
    
    _server = [ServerManager sharedInstance];
    [self requestQueueInfo];
    [self requestQRCode];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[UIScreen mainScreen] setBrightness:0.8];
    [super viewDidAppear:animated];
    [self remoteNotification];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationIdScan object:nil];
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
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

-(QRCodeView *)QRCode
{
    if (!_QRCode) {
        _QRCode = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, QRCodeSize, QRCodeSize)];
        [_QRCode setCenter:CGPointMake(kScreen_Width/2, itemHeight+topMargin+QRCodeSize/2)];
    }
    return _QRCode;
}

-(WorkStatusView *)statusView
{
    if (!_statusView) {
        _statusView = [[WorkStatusView alloc] init];
        [_statusView setFrame:CGRectMake(k_Margin, 0, kScreen_Width - 2*k_Margin, itemHeight)];
    }
    return _statusView;
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return itemHeight;
    }
    else if(indexPath.section == 1){
        return itemHeight*3;
    }
    else
    {
        CGFloat content = itemHeight+topMargin*2+QRCodeSize;
        return content;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    for (UIView* subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    if (indexPath.section == 0) {

        [cell.contentView addSubview:self.statusView];
        [self.statusView setData:_viewModel.reportArray];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UILabel* queueNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight)];
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeight, kScreen_Width, itemHeight)];
        UILabel* location = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeight*2, kScreen_Width, itemHeight)];
        queueNo.textAlignment = NSTextAlignmentCenter;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        location.textAlignment = NSTextAlignmentCenter;
        if (![_viewModel.queueno isEqualToString:@""]&&_viewModel.queueno) {
            
        }
        queueNo.text = [NSString stringWithFormat:@"序号: %@", _viewModel.queueno];
        queueNo.font = [UIFont systemFontOfSize:18];
        queueNo.textColor = COLOR_WithHex(0x565656);
        if([_viewModel.queueno isEqualToString:@""])
        {
            queueNo.hidden = YES;
        }
        else
        {
            queueNo.hidden = NO;
        }
        
        if (![_viewModel.storename isEqualToString:@""]) {
            NSString* locationString = [NSString stringWithFormat: @"%@: %@", _viewModel.store , _viewModel.storename];
            NSMutableAttributedString* atrLocationStr = [[NSMutableAttributedString alloc] initWithString:locationString];
            [atrLocationStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_GRAY range:NSMakeRange(0, [_viewModel.store length]+1)];
            [atrLocationStr addAttribute:NSForegroundColorAttributeName value:COLOR_WithHex(0x565656) range:NSMakeRange([_viewModel.store length]+1, [atrLocationStr.string length]-[_viewModel.store length]-1)];
            [atrLocationStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [atrLocationStr.string length])];
            
            [location setAttributedText:atrLocationStr];
            
            [cell.contentView addSubview:location];
        }
        
        if (![_viewModel.expecttime isEqualToString:@""]) {
            NSString* timeString = [NSString stringWithFormat:@"%@: %@", _viewModel.time, _viewModel.expecttime];
            NSMutableAttributedString* atrTimeStr = [[NSMutableAttributedString alloc] initWithString:timeString];
            [atrTimeStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_GRAY range:NSMakeRange(0, [_viewModel.time length]+1)];
            [atrTimeStr addAttribute:NSForegroundColorAttributeName value:COLOR_WithHex(0x565656) range:NSMakeRange([_viewModel.time length]+1, [atrTimeStr.string length]-[_viewModel.time length]-1)];
            [atrTimeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [atrTimeStr.string length])];
            [timeLabel setAttributedText:atrTimeStr];
            [cell.contentView addSubview:timeLabel];
        }
        
        [cell.contentView addSubview:queueNo];
        
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
        return 0.01;
    }
    else
        return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
    //[self generateReport];
}

-(void)generateReport
{
    ReportViewController* reportVC = [[ReportViewController alloc] init];
    [reportVC setTransportID:self.transportID];
    [self.navigationController pushViewController:reportVC animated:YES];
}

-(void)requestQRCode
{
    NSDate* now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary* content = @{@"generatetime":[dateFormatter stringFromDate:now],
                              @"transportid":[NSString stringWithFormat:@"%lu",(long)_transportID]};
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
    NSString* data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.QRCode setQRCode:data];
}

-(void)requestQueueInfo
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"id":[NSString stringWithFormat:@"%lu",(long)_transportID]};
    [_server GET:@"getQueueDetail" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"response:%@", responseObject);
        NSDictionary* data = responseObject[@"data"];
        NSError* error;
        _viewModel = [MTLJSONAdapter modelOfClass:[queueViewModel class] fromJSONDictionary:data error:&error];
        if (!error) {
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@", error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark phone calls
-(void)remoteNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:notificationIdScan object:nil];
    
}

-(void)getNotification:(NSNotification *)notification
{
    if([notification.userInfo[@"content"] isEqualToString:@"outfactory"])
    {
        [self generateReport];
    }
    else
    {
        [self requestQueueInfo];
    }
}

#pragma mark navigation item
-(void)phoneCall:(id)sender
{
    if (_viewModel.factoryphone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_viewModel.factoryphone]]];
    }
    else
    {
        
    }
}
 
@end
