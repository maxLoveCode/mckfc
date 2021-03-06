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
#import "nofityViewController.h"
#import "AlertHUDView.h"

#import "RedPocketButton.h"
#import "User.h"
#import "RewardDetailView.h"
#import "OnRouteRightItemsView.h"
#import "LoginNav.h"
#define itemHeight 44
#define topMargin 60

@interface QueueViewController ()<UITableViewDelegate, UITableViewDataSource,HUDViewDelegate,didClickMenuDelegate>
{
    NSArray* titleText;
    OnRouteRightItemsView *_menuView;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) QRCodeView* QRCode;
@property (nonatomic, strong) WorkStatusView* statusView;
@property (nonatomic, strong) ServerManager* server;


@property (nonatomic, assign) NSInteger transportID;
@property (nonatomic, strong) queueViewModel* viewModel;
@property (nonatomic, strong) AlertHUDView* alert;
@property (nonatomic, strong) UIButton* botBtn;

@property (nonatomic, strong) RedPocketButton* redPocket;
@property (nonatomic, strong) User* user;

@end

@implementation QueueViewController

-(instancetype)initWithID:(NSInteger)transportID
{
    self = [super init];
    self.transportID = transportID;
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem* phone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"系统设置"] style:UIBarButtonItemStylePlain target:self action:@selector(phoneCall:)];
    self.navigationItem.rightBarButtonItem = phone;
    return self;
}

-(void)viewDidLoad
{
    self.title = @"厂前排队";
    titleText = @[@"预计厂前等待时间：",@"仓库位置："];
    
    [self.view addSubview: self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.server = [ServerManager sharedInstance];
    [self requestQueueInfo];
    [self requestQRCode];
    
    [self.redPocket attachToView:self.view];
    [self.redPocket setHidden:NO];
    [self remoteNotification];
    [self requestUserInfo];

}

-(void)viewDidAppear:(BOOL)animated
{
    [[UIScreen mainScreen] setBrightness:0.8];
    [super viewDidAppear:animated];
    
  
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationIdScan object:nil];
}

#pragma mark - setter properties

-(RedPocketButton *)redPocket
{
    if (!_redPocket) {
        _redPocket = [[RedPocketButton alloc] init];
    }
    return _redPocket;
}

-(AlertHUDView *)alert
{
    if (!_alert) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.delegate = self;
    }
    return _alert;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Queue"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        
        [self.tableView addSubview: self.botBtn];
        
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

-(UIButton *)botBtn
{
    if (!_botBtn) {
        _botBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_botBtn setTitle:@"《入场注意事项》" forState: UIControlStateNormal];
        [_botBtn setTitleColor:COLOR_WithHex(0x565656) forState:UIControlStateNormal];
        [_botBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_botBtn setBackgroundColor:[UIColor clearColor]];
        [_botBtn addTarget:self action:@selector(notifypage:) forControlEvents:UIControlEventTouchUpInside];
        
        [_botBtn sizeToFit];
    }
    return _botBtn;
}



#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
//    else if(indexPath.section == 1)
//    {
//        UILabel* queueNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight)];
//        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeight, kScreen_Width, itemHeight)];
//        UILabel* location = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeight*2, kScreen_Width, itemHeight)];
//        queueNo.textAlignment = NSTextAlignmentCenter;
//        timeLabel.textAlignment = NSTextAlignmentCenter;
//        location.textAlignment = NSTextAlignmentCenter;
//        
//        queueNo.text = [NSString stringWithFormat:@"序号: %@", _viewModel.queueno];
//        queueNo.font = [UIFont systemFontOfSize:18];
//        queueNo.textColor = COLOR_WithHex(0x565656);
//        if([_viewModel.queueno isEqualToString:@""]|| !_viewModel.queueno)
//        {
//            queueNo.hidden = YES;
//        }
//        else
//        {
//            queueNo.hidden = NO;
//        }
//        
//        if ( !([_viewModel.storename isEqualToString:@""] || !_viewModel.storename)) {
//            NSString* locationString = [NSString stringWithFormat: @"%@: %@", _viewModel.store , _viewModel.storename];
//            NSMutableAttributedString* atrLocationStr = [[NSMutableAttributedString alloc] initWithString:locationString];
//            [atrLocationStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_GRAY range:NSMakeRange(0, [_viewModel.store length]+1)];
//            [atrLocationStr addAttribute:NSForegroundColorAttributeName value:COLOR_WithHex(0x565656) range:NSMakeRange([_viewModel.store length]+1, [atrLocationStr.string length]-[_viewModel.store length]-1)];
//            [atrLocationStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [atrLocationStr.string length])];
//            
//            [location setAttributedText:atrLocationStr];
//            
//            [cell.contentView addSubview:location];
//        }
//        
//        if ( !([_viewModel.expecttime isEqualToString:@""] || !_viewModel.expecttime)) {
//            NSString* timeString = [NSString stringWithFormat:@"%@: %@", _viewModel.time, _viewModel.expecttime];
//            NSMutableAttributedString* atrTimeStr = [[NSMutableAttributedString alloc] initWithString:timeString];
//            [atrTimeStr addAttribute:NSForegroundColorAttributeName value:COLOR_TEXT_GRAY range:NSMakeRange(0, [_viewModel.time length]+1)];
//            [atrTimeStr addAttribute:NSForegroundColorAttributeName value:COLOR_WithHex(0x565656) range:NSMakeRange([_viewModel.time length]+1, [atrTimeStr.string length]-[_viewModel.time length]-1)];
//            [atrTimeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [atrTimeStr.string length])];
//            [timeLabel setAttributedText:atrTimeStr];
//            [cell.contentView addSubview:timeLabel];
//        }
//        
//        [cell.contentView addSubview:queueNo];
//        
//        return cell;
//    }
    else
    {
        UILabel* label =[[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-k_Margin*2, itemHeight*2)];
        label.text = @"到厂后请出示下列二维码，厂前人员可快速验收运输信息";
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
//    if (section == 0) {
//        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight)];
//        [view setBackgroundColor:[UIColor whiteColor]];
//        return view;
//    }
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

-(void)requestUserInfo
{
    //根据 access token 判断第一次
    if (_server.accessToken) {
        NSDictionary* params = @{@"token": _server.accessToken};
        [_server GET:@"getUserInfo" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary* data = responseObject[@"data"];
            _user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:nil];
            [self checkRedPocketByUser:_user];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

#pragma mark- redPocket
//firstly check the red pocket is need to be hidden or not
-(void)checkRedPocketByUser:(User*)user
{
    if([user.redrule isEqualToString:@""]||user.redrule == nil)
    {
        [self.redPocket setHidden:YES];
    }
    else
    {
        [self.redPocket setHidden:NO];
        [self.redPocket setString:user.reward];
        [self.redPocket.claim addTarget:self action:@selector(claim:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark- claim +modal view
//its the modal uiview to present so I put the ui rendering inside the method
-(void)claim:(id)sender
{
    RewardDetailView* rewardView = [[RewardDetailView alloc] init];
    [rewardView show];
    
    [rewardView setContentString:_user.redrule];
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
            NSString* isRead = [[NSUserDefaults standardUserDefaults] objectForKey:isReadQueueNotification];
            if ( [isRead isEqualToString:@"0"] || isRead == nil) {
                [self readBookletPrompt];
            }
            self.title = [_viewModel generateTitle];
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
    [self requestUserInfo];
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
    _menuView = [[OnRouteRightItemsView alloc]init];
    _menuView.menuDelegate = self;
    [_menuView addSubViews];

}

- (void)exitView{
    [_menuView removeSubViews];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user_type"];
    [defaults removeObjectForKey:@"access_token"];
    LoginNav* loginVC = [[LoginNav alloc] init];
    [self presentViewController:loginVC animated:NO completion:^{
    }];
}

- (void)callPhone{
        if (_viewModel.factoryphone) {
            [_menuView removeSubViews];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_viewModel.factoryphone]]];
        }
        else
        {
    
        }
}

#pragma mark - notifypage
-(void)notifypage:(id)sender
{
    if (_viewModel.queuenotes != nil) {
        nofityViewController* notify = [[nofityViewController alloc] initWithString:_viewModel.queuenotes];
        [self.navigationController pushViewController:notify animated:YES];
    }
}

#pragma mark-alertview delegate
-(void)didSelectConfirm
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:isReadQueueNotification];
    [self notifypage:nil];
    [self.alert removeFromSuperview];
}

-(void)readBookletPrompt
{
    self.alert.title.text = @"入场注意事项";
    self.alert.detail.text = @"司机请查看入场注意事项";
    self.alert.detail.numberOfLines = 0;
    [self.alert show:_alert];
}

-(void)viewWillLayoutSubviews
{
    [self.botBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.bottom).with.offset(kScreen_Height-80);
        make.centerX.equalTo(self.tableView);
    }];
}

@end
