//
//  FarmerPlanViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//


// 啊啊啊奇怪的需求和不匹配的设计导致了这个模块是整块代码里最垃圾的一块
// 头痛

#import "FarmerPlanViewController.h"
#import "FarmerPlanView.h"
#import "FarmerQRCodeVC.h"
#import "SettingViewController.h"
#import "AddRecordViewController.h"
#import "MCPickerView.h"
#import "MCDatePickerView.h"
#import "AlertHUDView.h"
#import "ServerManager.h"
#import "QRDetailController.h"
#import "CreatQRCodeView.h"
#import "CreatQRViewController.h"
#import "DriverUploadImgViewController.h"
#import "TODOViewController.h"
#import "WorkRecordViewController.h"
#define buttonHeight 40
#define itemHeight 44

@interface FarmerPlanViewController ()<FarmerPlanViewDelegate, MCPickerViewDelegate,HUDViewDelegate,DatePickerDelegate, AddRecordTableDelegate, FarmerQRCodeVCDelegate,didClickUploadImgDelegate>
{
    NSArray* vendorList;
    NSArray* cityList;
    NSArray* fieldList;
    NSArray* DateList;
    NSArray* uploadList;
    NSArray* factoryList;
    double _planeDuration;
}

//main tableview of the homepage
@property (nonatomic, strong) FarmerPlanView* farmerPlanview;

//child vcs
@property (nonatomic, strong) FarmerQRCodeVC* QRVC;
@property (nonatomic, strong) AddRecordViewController* addRecordVC;

@property (nonatomic, strong) ServerManager* server;

@property (nonatomic, strong) UIButton* botButton;
@property (nonatomic, strong) UIButton* backToHistoryButton;

@property (nonatomic, strong) MCPickerView* pickerView;
@property (nonatomic, strong) AlertHUDView* alert;
@property (nonatomic, strong) MCDatePickerView* datePicker;

@property (nonatomic, strong) NSMutableArray* transportationList; //发运订单
@property (nonatomic, strong) NSMutableArray* historyList; //历史订单


@end

@implementation FarmerPlanViewController

-(void)viewDidLoad
{
    self.view = self.farmerPlanview;
    
    _server = [ServerManager sharedInstance];
    self.title = @"运输计划";
    if (!_transportationList) {
        _transportationList = [[NSMutableArray alloc] init];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.botButton.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.botButton.hidden = NO;
}
#pragma mark- property setters


-(FarmerPlanView *)farmerPlanview
{
    if (!_farmerPlanview) {
        _farmerPlanview = [[FarmerPlanView alloc] init];
        _farmerPlanview.planViewDelegate = self;
        _farmerPlanview.creatQRCodeView.uploadImgDelegate = self;
    }
    return _farmerPlanview;
}

-(MCPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[MCPickerView alloc] init];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

-(AlertHUDView *)alert
{
    if (!_alert) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.delegate = self;
        _alert.title.text = @"错误";
    }
    return _alert;
}

-(MCDatePickerView *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[MCDatePickerView alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}

-(UIButton *)botButton
{
    if (!_botButton) {
        _botButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_botButton setTitle:@"确认并保存" forState:UIControlStateNormal];
        [_botButton setBackgroundColor:COLOR_THEME];
        [_botButton setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        [_botButton setFrame:CGRectMake(0, kScreen_Height-buttonHeight, kScreen_Width, buttonHeight)];
        
        [_botButton addTarget:self action:@selector(botButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _botButton;
}

-(UIButton *)backToHistoryButton
{
    if (!_backToHistoryButton) {
        _backToHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backToHistoryButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backToHistoryButton setBackgroundColor:COLOR_THEME];
        [_backToHistoryButton setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        [_backToHistoryButton setFrame:CGRectMake(0, kScreen_Height-buttonHeight, kScreen_Width, buttonHeight)];
        
        [_backToHistoryButton addTarget:self action:@selector(backToHistory:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToHistoryButton;
}

-(void)addReturnButton
{
    UIBarButtonItem* item = self.navigationItem.leftBarButtonItem;
    if (!item) {
        UIBarButtonItem* newItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style: UIBarButtonItemStylePlain target:self action:@selector(popToMenu:)];
        self.navigationItem.leftBarButtonItem = newItem;
    }
}

-(void)removeReturnButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - menu selection
-(void)menu:(FarmerPlanView *)Menu DidSelectIndex:(NSInteger)index
{
#warning 需要修改的地方
    if (index == 0) {
//        _farmerPlanview.type = FarmerPlanViewTypeQRCode;
//        _QRVC = [[FarmerQRCodeVC alloc] init];
//        _QRVC.delegate = self;
//        [self addChildViewController:_QRVC];
//        [_QRVC setQRData:@""];
//        _farmerPlanview.qrCodeView = (FarmerQRCodeView*)_QRVC.view;
        
        //[self menu:Menu DidSelectIndex:1];
        
        if (!_farmerPlanview.stats.field.fieldID) {
            self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择地块";
            [self.alert show:self.alert];
        }else{
            NSInteger fieldID =  _farmerPlanview.stats.field.fieldID;
            CreatQRViewController *qr = [[CreatQRViewController alloc] init];
            qr.numberCode = [NSString stringWithFormat:@"%lu",(long)fieldID];
            [self.navigationController pushViewController:qr animated:NO];
        }
       
    }
    else if (index == 1)
    {
        if (!_farmerPlanview.stats.departuretime) {
            self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择运输时间";
            [self.alert show:self.alert];
        }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.botButton];
        [_botButton setTitle:@"一键清空" forState:UIControlStateNormal];
        if (!_addRecordVC) {
            _addRecordVC = [[AddRecordViewController alloc] init];
            [self addChildViewController:_addRecordVC];
            _addRecordVC.delegate = self;
        }
            self.addRecordVC.serialnoEnable = NO;
            if (_planeDuration && _planeDuration > 0) {
                _addRecordVC.planeDuration = _planeDuration;
            }
//            _addRecordVC.terminateLatitude = _farmerPlanview.stats.pointy;
//            _addRecordVC.terminateLongtitude = _farmerPlanview.stats.pointx;
        _farmerPlanview.type = FarmerPlanViewTypeRecordList;
        _farmerPlanview.datasource = self.transportationList;
        _farmerPlanview.addRecordView = _addRecordVC.tableView;
        [self reload];
        }
    }
    else if (index == 2)
    {
        if (!_farmerPlanview.stats.field.fieldID) {
            self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择地块";
            [self.alert show:self.alert];
        }else{
            NSInteger fieldID =  _farmerPlanview.stats.field.fieldID;
            _farmerPlanview.type = FarmerPlanViewTypeCodeQR;
            _farmerPlanview.creatQRCodeView.numberCode = [NSString stringWithFormat:@"%lu",(long)fieldID];
            [self addReturnButton];
            [self reload];
            
        }
//        [self requestUploadListsuccess:^(NSMutableArray *result) {
//            _farmerPlanview.type = FarmerPlanViewTypeHistory;
//            self.historyList = result;
//            _farmerPlanview.datasource = result;
//            _addRecordVC = [[AddRecordViewController alloc] init];
//            [self addChildViewController:_addRecordVC];
//            _addRecordVC.delegate = self;
//            _farmerPlanview.addRecordView = _addRecordVC.tableView;
//            [self addReturnButton];
//            [self reload];
//        }];
    }
    else if(index == 5)
    {
        SettingViewController* setting = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }else if (index ==3){
        TODOViewController* todoVC = [[TODOViewController alloc] init];
        todoVC.isVendor = YES;
        [self.navigationController pushViewController:todoVC animated:YES];
    }else if (index == 4){
        WorkRecordViewController *WRVC = [[WorkRecordViewController alloc] init];
        WRVC.isVendor = YES;
        [self.navigationController pushViewController:WRVC animated:YES];
    }
    
    if (Menu.type == FarmerPlanViewTypeMenu) {
    }
    else
    {
        [self addReturnButton];
    }
}

#pragma mark - table selection
-(void)tableStats:(UITableView *)table DidSelectIndex:(NSInteger)index
{
    self.pickerView.index = [NSIndexPath indexPathForRow:index inSection:0];
    if (index == 0) {
        
        if (cityList == nil || [cityList count] == 0) {
            [self requestCityListSuccess:^{
                [self.pickerView setData:cityList];
                [self.pickerView show];
                
                if (!_farmerPlanview.stats.city) {
                    _farmerPlanview.stats.city = cityList[0];
                    City *city = cityList[0];
                    _planeDuration = [city.time doubleValue];
                }
                [self reload];
            }];
        }
        else
        {
            [self.pickerView setData:cityList];
            [self.pickerView show];
        }
    }
    else if (index == 1){
        
        City* city = _farmerPlanview.stats.city;
        if (!city) {
           self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择城市";
            [self.alert show:self.alert];
        }
        else
        {
            [self requestVendors:city.areaid success:^{
                [self.pickerView setData:vendorList];
                [self.pickerView show];
            
                if (!_farmerPlanview.stats.supplier) {
                    _farmerPlanview.stats.supplier = vendorList[0];
                }
                [self reload];
            }];
        }
    }
    else if (index == 2){
        Vendor* vendor = _farmerPlanview.stats.supplier;
        if (!vendor) {
            self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择供应商";
            [self.alert show:self.alert];
        }
        else
        {
            [self requestFields:[NSString stringWithFormat:@"%lu", (long)vendor.vendorID]
             City:_farmerPlanview.stats.city.areaid
                success:^{
                [self.pickerView setData:fieldList];
                [self.pickerView show];
                
                    if (!_farmerPlanview.stats.field) {
                        _farmerPlanview.stats.field = fieldList[0];
                    }
                [self reload];
            }];
        }
    }
    else if (index == 3){
        Field* field = _farmerPlanview.stats.field;
        //如果没有地块先选地块
        if (!field) {
            self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择地块";
            [self.alert show:self.alert];
        }
        else //加载网络
        {
            [self requestFactoryList:[NSString stringWithFormat:@"%lu", (long)field.fieldID] success:^{
                
                [self.pickerView setData:factoryList];
                [self.pickerView show];
                
                if (!_farmerPlanview.stats.factory) {
                    _farmerPlanview.stats.factory = factoryList[0];
                    Factory *factory = factoryList[0];
                    _farmerPlanview.stats.pointx = factory.pointx;
                    _farmerPlanview.stats.pointy = factory.pointy;
                }
                [self reload];
            }];
        }
    }
    else if (index == 4){
        Field* field = _farmerPlanview.stats.field;
        Factory* factory = _farmerPlanview.stats.factory;
        if (!field) {
            self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择地块";
            [self.alert show:self.alert];
        }
        else if(!factory)
        {
            self.alert.title.text = @"错误";
            self.alert.detail.text = @"请先选择工厂";
            [self.alert show:self.alert];
        }
        else
        {
            [self requestDates:[NSString stringWithFormat:@"%lu", (long)field.fieldID]
                       factory:[NSString stringWithFormat:@"%lu", (long)[factory.factoryid integerValue]]
                       success:^{
                [self.pickerView setData:DateList];
                [self.pickerView show];
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                if (!_farmerPlanview.stats.departuretime) {
                    _farmerPlanview.stats.departuretime = [dateFormatter dateFromString:DateList[0]];
                }
                [self reload];
            }];
        }
    }
    else if (index == 10){
        self.farmerPlanview.type = FarmerPlanViewTypeOrder;
        self.addRecordVC.user = [[User alloc] init];
        self.addRecordVC.stats = [[LoadingStats alloc] init];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"HH:mm"];
        NSDateFormatter* formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *newDate =  [NSDate date];
        NSString *time = [formatter2 stringFromDate: newDate];
        NSString *date = [formatter stringFromDate:self.addRecordVC.stats.departuretime];
        NSString *dateAndTimeStr = [NSString stringWithFormat:@"%@ %@",date,time];
        NSDate *dateAndTime = [formatter3 dateFromString:dateAndTimeStr];
        self.addRecordVC.stats.departuretime = dateAndTime;
        self.addRecordVC.stats.planarrivetime = [NSDate dateWithTimeInterval:60 * 60 sinceDate:[NSDate date]];
        [self.addRecordVC.tableView reloadData];
        [_botButton setTitle:@"确认并上传" forState:UIControlStateNormal];
        [self reload];
    }
    else if (index >= 201 && self.farmerPlanview.type == FarmerPlanViewTypeRecordList) //看不懂了吗，没错，实在太混乱了，参照 farmerplanview
    {
        NSInteger i = index-201; //data index
        NSDictionary* data = _transportationList[i];
        self.addRecordVC.serialnoEnable = YES;
        self.addRecordVC.user = data[@"user"];
        self.addRecordVC.stats = data[@"stat"];
        self.farmerPlanview.type = FarmerPlanViewTypeDetail;
        [_botButton setTitle:@"确认" forState:UIControlStateNormal];
        [self reload];
    }
    else if(self.farmerPlanview.type == FarmerPlanViewTypeHistory && index >3000)
    {
        NSInteger i = index-3001; //data index
        NSDictionary* data = _historyList[i];
        self.addRecordVC.user = data[@"user"];
        self.addRecordVC.stats = data[@"stat"];
        [self.addRecordVC.tableView reloadData];
        self.farmerPlanview.type = FarmerPlanViewTypeDetail;
        [[UIApplication sharedApplication].keyWindow addSubview:self.backToHistoryButton];
        [self reload];
    }

}

-(void)popToMenu:(id)sender
{
    [self removeReturnButton];
    [self.botButton removeFromSuperview];
    self.farmerPlanview.type = FarmerPlanViewTypeMenu;
    [self.farmerPlanview.mainTableView reloadData];
    [self.backToHistoryButton removeFromSuperview];
}

#pragma mark uploads and data operations
-(void)botButton:(id)sender
{
    if (_farmerPlanview.type == FarmerPlanViewTypeOrder) {
        if ([self validation]) {
            NSDictionary* data = @{@"user":self.addRecordVC.user,
                                   @"stat":self.addRecordVC.stats};
            
            //[self.transportationList addObject:data];
            [self.transportationList insertObject:data atIndex:0];
            self.farmerPlanview.datasource = self.transportationList;
            [_botButton setTitle:@"一键清空" forState:UIControlStateNormal];
            _farmerPlanview.type = FarmerPlanViewTypeRecordList;
            [self reload];
            [self uploadDatas];
        }
    }
    else if (_farmerPlanview.type == FarmerPlanViewTypeRecordList)
    {
        [self.transportationList removeAllObjects];
        self.farmerPlanview.datasource = self.transportationList;
        [self reload];
    }
    else if (_farmerPlanview.type == FarmerPlanViewTypeDetail)
    {
        _addRecordVC.serialnoEnable = NO;
        _farmerPlanview.type = FarmerPlanViewTypeRecordList;
        [_botButton setTitle:@"一键清空" forState:UIControlStateNormal];
        [self reload];
    }
}

#pragma mark- web data requests
-(void)requestCityListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getAreaList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSLog(@"-----%@",jsonArray);
        NSError* error;
        cityList = [MTLJSONAdapter modelsOfClass:[City class] fromJSONArray:jsonArray error:&error];
        if (cityList && [cityList count] != 0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestVendors:(NSString*)city success:(void (^)(void))success
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"areaid":city};
    [_server GET:@"getVendorList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* data = responseObject[@"data"];
        vendorList = [MTLJSONAdapter modelsOfClass:[Vendor class] fromJSONArray:data error:nil];
        if (vendorList && [vendorList count] >0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestFields:(NSString*)vendor City:(NSString*)cityid success:(void (^)(void))success
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"vendorid":vendor,
                             @"areaid":cityid};
    [_server GET:@"getFieldList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* data = responseObject[@"data"];
        fieldList = [MTLJSONAdapter modelsOfClass:[Field class] fromJSONArray:data error:nil];
        if (fieldList && [fieldList count] >0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestDates:(NSString*)field factory:(NSString*)factory success:(void (^)(void))success
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"fieldid":field,
                             @"factoryid":factory};
    [_server GET:@"getPlanDateList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* data = responseObject[@"data"];
        DateList = data;
        
        if (DateList && [DateList count] >0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestFactoryList:(NSString*)field success:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken,
                             @"fieldid":field};
    [_server GET:@"getFactoryList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        factoryList = [MTLJSONAdapter modelsOfClass:[Factory class] fromJSONArray:jsonArray error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        if (factoryList || [factoryList count] != 0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestUploadListsuccess:(void (^)(NSMutableArray *result))success
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [dateFormatter stringFromDate:_farmerPlanview.stats.departuretime];
    if (!dateString) {
        dateString = @"";
    }
    NSString* factoryid = [NSString stringWithFormat:@"%lu", (long)[_farmerPlanview.stats.factory.factoryid integerValue]];
    
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"departuretime":dateString,
                             @"fieldid":[NSString stringWithFormat:@"%lu",(long)_farmerPlanview.stats.field.fieldID],
                             @"factoryid":factoryid};
    NSLog(@"%@",params);
    if ([factoryid isEqualToString:@"0"]) {
        return;
    }
    else
    {
    [_server GET:@"getUploadList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* data = responseObject[@"data"];
        NSLog(@"%@",data);
        NSArray* userPart = [MTLJSONAdapter modelsOfClass:[User class] fromJSONArray:data error:nil];
        NSMutableArray* records = [[NSMutableArray alloc] init];
        for (NSInteger i=0 ; i<[data count] ;i ++) {
            LoadingStats* stats = [[LoadingStats alloc] init];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [stats setDeparturetime:[dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", dateString, [data[i] objectForKey:@"departuretime"]]]];
            [stats setWeight:[data[i] objectForKey:@"weight"]];
            [stats setSerialno:[data[i] objectForKey:@"serialno"]];
            stats.package = [[Package alloc]init];
            stats.package.packageid = [data[i] objectForKey:@"packageid"];
            stats.package.name = [data[i] objectForKey:@"packagename"];
            stats.supplier =  _farmerPlanview.stats.supplier;
            stats.field = _farmerPlanview.stats.field;
            stats.factory = _farmerPlanview.stats.factory;
            
            User* user = userPart[i];
            user.region = [user.truckno substringWithRange:NSMakeRange(0, 1)];
            user.cardigits = [user.truckno substringWithRange:NSMakeRange(1, [user.truckno length]-1)];
            NSDictionary* data = @{@"user": userPart[i],
                                   @"stat": stats};
            [records addObject:data];
        }
        if (records) {
            success(records);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    }
}

-(void)uploadDatas
{
    NSMutableArray* unions = [[NSMutableArray alloc] init];
   // for (NSDictionary* trucks in _transportationList) {
    NSDictionary* trucks =  _transportationList.firstObject;
        User* user = [trucks objectForKey:@"user"];
        LoadingStats* stat = [trucks objectForKey:@"stat"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString* dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
        if ([stat.serialno length] < 6) {
           stat.serialno = [NSString stringWithFormat:@"17%@",stat.serialno];
        }
        NSString *planStr = [dateFormatter2 stringFromDate:stat.planarrivetime];
        NSDictionary* unionDic = @{@"driver":user.driver,
                                   @"mobile":user.mobile,
                                   @"truckno":user.truckno,
                                   @"serialno":stat.serialno,
                                   @"departuretime":dateString,
                                   @"storageid": [NSNumber numberWithInteger: [stat.storage.storageid integerValue]],
                                   @"varietyid": [NSNumber numberWithInteger: [stat.variety.varietyid integerValue]],
                                   @"planarrivetime":planStr,
                                   @"weight":stat.weight,
                                   @"packageid": @1};
        NSLog(@"----%@",unionDic);
        [unions addObject:unionDic];
   // }
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:unions options:NSJSONWritingPrettyPrinted error:nil];
    NSString* data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   // NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:_farmerPlanview.stats.departuretime];
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"vendorid":[NSString stringWithFormat:@"%lu",(long)_farmerPlanview.stats.supplier.vendorID],
                             @"fieldid":[NSString stringWithFormat:@"%lu",(long)_farmerPlanview.stats.field.fieldID],
                             @"trucks":data,
                             @"departureday":dateStr,
                             @"factoryid":[NSNumber numberWithInteger: [_farmerPlanview.stats.factory.factoryid integerValue]]
                             };
    NSLog(@"%@",params);
    [_server POST:@"uploadTransport" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
//        self.alert.title.text = @"成功";
//        self.alert.detail.text = @"上传完成";
//        [self.alert show:self.alert];
       // self.transportationList = [[NSMutableArray alloc] init];
        if ([responseObject[@"code"] integerValue] == 10000) {
            self.farmerPlanview.datasource = self.transportationList;
            [self reload];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark- MCPickerView delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //select city
    if (pickerView.index.row == 0) {
        _farmerPlanview.stats.city = cityList[row];
        City *city = cityList[row];
        _planeDuration = [city.time doubleValue];
    }
    else if(pickerView.index.row == 1){
        _farmerPlanview.stats.supplier = vendorList[row];
    }
    else if(pickerView.index.row == 2){
        _farmerPlanview.stats.field = fieldList[row];
    }
    else if(pickerView.index.row == 3){
        _farmerPlanview.stats.factory = factoryList[row];
        Factory *factory = factoryList[row];
        _farmerPlanview.stats.pointx = factory.pointx;
        _farmerPlanview.stats.pointy = factory.pointy;
    }
    else if(pickerView.index.row ==4){
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *newDate = [NSDate date];
        NSDate* date = [dateFormatter dateFromString:DateList[row]];
        if ([self compareOneDay:newDate withAnotherDay:date] >0) {
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该时间过期无效" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertCon addAction:act];
            [self presentViewController:alertCon animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [alertCon dismissViewControllerAnimated:NO completion:nil];
            }];
        }else{
            _farmerPlanview.stats.departuretime =date;
            NSLog(@"selection %@", _farmerPlanview.stats.departuretime);
            [self.addRecordVC setDate:date];
        }
        
    }
    [self reload];
}

#pragma mark reload shorthand
-(void)reload
{
    if (self.farmerPlanview.type == FarmerPlanViewTypeQRCode)
    {
        [self generateQRCode];
    }
    else if(self.farmerPlanview.type == FarmerPlanViewTypeHistory)
    {
        [self requestUploadListsuccess:^(NSMutableArray *result) {
            self.historyList = result;
             _farmerPlanview.datasource = result;
            [_farmerPlanview.mainTableView reloadData];
        }];
    }
    if (self.addRecordVC.stats != nil) {
        self.addRecordVC.stats.city = self.farmerPlanview.stats.city;
        self.addRecordVC.stats.supplier = self.farmerPlanview.stats.supplier;
        self.addRecordVC.stats.factory = self.farmerPlanview.stats.factory;
        self.addRecordVC.stats.field = self.farmerPlanview.stats.field;
        //self.addRecordVC.stats.de
        if (self.addRecordVC.stats.departuretime != nil
            && self.farmerPlanview.stats.departuretime != nil) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"HH:mm"];
            NSDateFormatter* formatter3 = [[NSDateFormatter alloc] init];
            [formatter3 setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString* substring1 = [formatter stringFromDate:self.farmerPlanview.stats.departuretime];
            NSString* substring2 = [formatter2 stringFromDate:self.addRecordVC.stats.departuretime];
            NSString* compond = [NSString stringWithFormat:@"%@ %@", substring1, substring2 ];
            NSDate* comDate = [formatter3 dateFromString:compond];
            self.addRecordVC.stats.departuretime = comDate;
            self.farmerPlanview.stats.departuretime = comDate;
        }
    }
    [_farmerPlanview.mainTableView reloadData];
}

#pragma mark alerts delegates
-(void)didSelectConfirm
{
    [_alert removeFromSuperview];
}

#pragma mark generate qrcode
-(void)generateQRCode
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (_farmerPlanview.stats.supplier) {
        [params addEntriesFromDictionary:@{@"providerId":[NSString stringWithFormat:@"%lu",(unsigned long)_farmerPlanview.stats.supplier.vendorID]}];
        [params addEntriesFromDictionary:@{@"provider":_farmerPlanview.stats.supplier.name}];
    }
    if (_farmerPlanview.stats.field) {
        [params addEntriesFromDictionary:@{@"landId":[NSString stringWithFormat:@"%lu",(unsigned long)_farmerPlanview.stats.field.fieldID]}];
        [params addEntriesFromDictionary:@{@"land":_farmerPlanview.stats.field.name}];
    }
    if (_farmerPlanview.stats.city) {
        [params addEntriesFromDictionary:@{@"city":[NSString stringWithFormat:@"%@",_farmerPlanview.stats.city.areaid]}];
    }
    if (_farmerPlanview.stats.departuretime) {
        [params addEntriesFromDictionary:@{@"time":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_farmerPlanview.stats.departuretime]]}];
    }
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString* data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self.QRVC setQRData:[NSString stringWithFormat:@"%@", data]];
}

#pragma mark datePicker delegate
-(void)datePickerViewDidSelectDate:(NSDate *)date
{
    _farmerPlanview.stats.departuretime = date;
    [self reload];
}

#pragma mark addRecord delegate
-(void)addRecordView:(AddRecordTable *)viewdidBeginEditing
{
    [self.farmerPlanview setContentOffset:CGPointMake(0, itemHeight*4+40) animated:YES];
    UIBarButtonItem* save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style: UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = save;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(save)];
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    mask.tag = 88;
    [mask addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:mask];
}

-(void)endEditing:(AddRecordTable *)viewEndEditing
{
    [self.farmerPlanview endEditing:YES];
    [self.farmerPlanview.addRecordView endEditing:YES];
    [self.farmerPlanview setContentOffset:CGPointMake(0, 0) animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)requestDate:(AddRecordViewController *)vc
{
    if (_farmerPlanview.stats.departuretime) {
        NSLog(@"%@", _farmerPlanview.stats.departuretime);
        [vc setDate:_farmerPlanview.stats.departuretime];
        [vc showDatePicker];
    }else if(_farmerPlanview.stats.planarrivetime){
         [vc setDate:_farmerPlanview.stats.planarrivetime];
        [vc showDatePicker];
    }
}

-(void)save
{
    for (UIView* view in [[UIApplication sharedApplication].keyWindow subviews]) {
        if (view.tag == 88) {
            [view removeFromSuperview];
        }
    }
    [self endEditing:self.addRecordVC.tableView];
}

#pragma mark- qrcodeView delegate
-(void)QRCodeViewDidSelectRecord:(FarmerQRCodeVC *)vc
{
    self.farmerPlanview.type = FarmerPlanViewTypeOrder;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.botButton];
    
    if (!_addRecordVC) {
        _addRecordVC = [[AddRecordViewController alloc] init];
        [self addChildViewController:_addRecordVC];
        _addRecordVC.delegate = self;
    }
    _farmerPlanview.addRecordView = _addRecordVC.tableView;
    
    [self reload];
}

#pragma mark- validation
- (BOOL)validation
{
    User* user = self.addRecordVC.user;
    LoadingStats* stat = self.addRecordVC.stats;
    self.alert.title.text = @"错误";
    if (!user.region || !user.cardigits) {
        self.alert.detail.text = @"请正确填写车牌号";
        [self.alert show:self.alert];
        return NO;
    }
    if (!user.driver) {
        self.alert.detail.text = @"请先填写司机姓名";
        [self.alert show:self.alert];
        return NO;
    }
    if (!user.mobile) {
        self.alert.detail.text = @"请先填写司机手机号";
        [self.alert show:self.alert];
        return NO;
    }
    if (!stat.serialno) {
        self.alert.detail.text = @"请先填写运输单号";
        [self.alert show:self.alert];
        return NO;
    }
    if (!stat.departuretime) {
        self.alert.detail.text = @"请先选择运输时间";
        [self.alert show:self.alert];
        return NO;
    }
    /*
    if (!stat.package) {
        self.alert.detail.text = @"请先选择包装类型";
        [self.alert show:self.alert];
        return NO;
    }
     */
    if (!stat.planarrivetime) {
        self.alert.detail.text = @"请先选择到达时间";
        [self.alert show:self.alert];
        return NO;
    }
    if (!stat.variety) {
        self.alert.detail.text = @"请先选择薯品种";
        [self.alert show:self.alert];
        return NO;
    }
    if (!stat.storage) {
        self.alert.detail.text = @"请先选择存储期";
        [self.alert show:self.alert];
        return NO;
    }
    return YES;
}

- (void)backToHistory:(id)sender
{
    [self.backToHistoryButton removeFromSuperview];
    _farmerPlanview.type = FarmerPlanViewTypeHistory;
    [self reload];
}

-(void)list:(UITableView *)table DidDeleteRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.transportationList removeObjectAtIndex:indexPath.row];
    [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tableView:(UITableView *)tableview DidSelectFarmerCell:(FarmerRecordCell *)cell
{
    if(cell.json)
    {
        QRDetailController* QRDetail = [[QRDetailController alloc] init];
        [QRDetail setData:cell.json];
        [self.navigationController pushViewController:QRDetail animated:YES];
    }
}

#pragma -mark 上传图片
- (void)didClickUpdateImg:(NSString *)fielduserid{
    DriverUploadImgViewController *uploadCon = [[DriverUploadImgViewController alloc]initWithNibName:@"DriverUploadImgViewController" bundle:nil];
    uploadCon.fielduserid = fielduserid;
    [self.navigationController pushViewController:uploadCon animated:NO];
}

#pragma mark --比较两个时间
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

@end
