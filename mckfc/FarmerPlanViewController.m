//
//  FarmerPlanViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "FarmerPlanViewController.h"
#import "FarmerPlanView.h"
#import "FarmerQRCodeVC.h"
#import "SettingViewController.h"
#import "AddRecordViewController.h"
#import "MCPickerView.h"
#import "MCDatePickerView.h"
#import "AlertHUDView.h"

#import "ServerManager.h"



#define buttonHeight 40
#define itemHeight 44

@interface FarmerPlanViewController ()<FarmerPlanViewDelegate, MCPickerViewDelegate,HUDViewDelegate,DatePickerDelegate, AddRecordTableDelegate>
{
    NSArray* vendorList;
    NSArray* cityList;
    NSArray* fieldList;
}

//main tableview of the homepage
@property (nonatomic, strong) FarmerPlanView* farmerPlanview;

//child vcs
@property (nonatomic, strong) FarmerQRCodeVC* QRVC;
@property (nonatomic, strong) AddRecordViewController* addRecordVC;

@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) UIButton* botButton;

@property (nonatomic, strong) MCPickerView* pickerView;
@property (nonatomic, strong) AlertHUDView* alert;
@property (nonatomic, strong) MCDatePickerView* datePicker;

@end

@implementation FarmerPlanViewController

-(void)viewDidLoad
{
    self.view = self.farmerPlanview;
    
    _server = [ServerManager sharedInstance];
}

#pragma mark -property setters
-(FarmerPlanView *)farmerPlanview
{
    if (!_farmerPlanview) {
        _farmerPlanview = [[FarmerPlanView alloc] init];
        _farmerPlanview.planViewDelegate = self;
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

#pragma mark menu selection
-(void)menu:(FarmerPlanView *)Menu DidSelectIndex:(NSInteger)index
{
    NSLog(@"%ld", (long)index);
    
    if (index == 0) {
        _farmerPlanview.type = FarmerPlanViewTypeQRCode;
        _QRVC = [[FarmerQRCodeVC alloc] init];
        [self addChildViewController:_QRVC];
        [_QRVC setQRData:@""];
        _farmerPlanview.qrCodeView = (FarmerQRCodeView*)_QRVC.view;
        [self reload];
    }
    else if (index == 1)
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self.botButton];
        
        _farmerPlanview.type = FarmerPlanViewTypeOrder;
        _addRecordVC = [[AddRecordViewController alloc] init];
        [self addChildViewController:_addRecordVC];
        _addRecordVC.delegate = self;
        _farmerPlanview.addRecordView = _addRecordVC.tableView;
        [self reload];
    }
    else if (index == 2)
    {
        
    }
    else
    {
        SettingViewController* setting = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }
    
    if (Menu.type == FarmerPlanViewTypeMenu) {
    }
    else
    {
        [self addReturnButton];
    }
}

#pragma mark table selection
-(void)tableStats:(UITableView *)table DidSelectIndex:(NSInteger)index
{
    self.pickerView.index = [NSIndexPath indexPathForRow:index inSection:0];
    if (index == 0) {
        
        if (cityList == nil || [cityList count] == 0) {
            [self requestCityListSuccess:^{
                [self.pickerView setData:cityList];
                [self.pickerView show];
                
                _farmerPlanview.stats.city = cityList[0];
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
            self.alert.detail.text = @"请先选择城市";
            [self.alert show:self.alert];
        }
        else
        {
            [self requestVendors:city.cityid success:^{
                [self.pickerView setData:vendorList];
                [self.pickerView show];
            
                _farmerPlanview.stats.supplier = vendorList[0];
                [self reload];
            }];
        }
    }
    else if (index == 2){
        Vendor* vendor = _farmerPlanview.stats.supplier;
        if (!vendor) {
            self.alert.detail.text = @"请先选择供应商";
            [self.alert show:self.alert];
        }
        else
        {
            [self requestFields:[NSString stringWithFormat:@"%lu", (long)vendor.vendorID] success:^{
                [self.pickerView setData:fieldList];
                [self.pickerView show];
                
                _farmerPlanview.stats.field = fieldList[0];
                NSLog(@"%@", _farmerPlanview.stats.field);
                [self reload];
            }];
        }
    }
    else if (index == 3){
        NSLog(@"tap");
        [self.datePicker show];
    }
}

-(void)popToMenu:(id)sender
{
    [self removeReturnButton];
    [self.botButton removeFromSuperview];
    self.farmerPlanview.type = FarmerPlanViewTypeMenu;
    [self.farmerPlanview.mainTableView reloadData];
}

-(void)botButton:(id)sender
{
    if (_farmerPlanview.type == FarmerPlanViewTypeOrder) {
        [_botButton setTitle:@"上传全部" forState:UIControlStateNormal];
        _farmerPlanview.type = FarmerPlanViewTypeRecordList;
        [self reload];
    }
    else
    {
        [_botButton setTitle:@"确认并保存" forState:UIControlStateNormal];
        _farmerPlanview.type = FarmerPlanViewTypeOrder;
        [self reload];
    }
}

#pragma mark -web data requests
-(void)requestCityListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getCityList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        cityList = [MTLJSONAdapter modelsOfClass:[City class] fromJSONArray:jsonArray error:&error];
        if (cityList) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestVendors:(NSString*)city success:(void (^)(void))success
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"city":city};
    [_server GET:@"getVendorList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* data = responseObject[@"data"];
        vendorList = [MTLJSONAdapter modelsOfClass:[Vendor class] fromJSONArray:data error:nil];
        if (vendorList && [vendorList count] >0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestFields:(NSString*)vendor success:(void (^)(void))success
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"vendorid":vendor};
    [_server GET:@"getFieldList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* data = responseObject[@"data"];
        fieldList = [MTLJSONAdapter modelsOfClass:[Field class] fromJSONArray:data error:nil];
        if (fieldList && [fieldList count] >0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark MCPickerView delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //select city
    if (pickerView.index.row == 0) {
        _farmerPlanview.stats.city = cityList[row];
    }
    else if(pickerView.index.row == 1){
        _farmerPlanview.stats.supplier = vendorList[row];
    }
    else if(pickerView.index.row == 2){
        _farmerPlanview.stats.field = fieldList[row];
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
        [params addEntriesFromDictionary:@{@"landId":[NSString stringWithFormat:@"%lu",(unsigned long)_farmerPlanview.stats.field.fieldID]}];        [params addEntriesFromDictionary:@{@"land":_farmerPlanview.stats.field.name}];
    }
    if (_farmerPlanview.stats.city) {
        [params addEntriesFromDictionary:@{@"city":[NSString stringWithFormat:@"%@",_farmerPlanview.stats.city.cityid]}];
    }
    if (_farmerPlanview.stats.departuretime) {
        [params addEntriesFromDictionary:@{@"time":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_farmerPlanview.stats.departuretime]]}];
    }
    [self.QRVC setQRData:[NSString stringWithFormat:@"%@", params]];
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
    NSLog(@"begin");
    [self.farmerPlanview setContentOffset:CGPointMake(0, itemHeight*4+40) animated:YES];
}

-(void)endEditing:(AddRecordTable *)viewEndEditing
{
    [self.farmerPlanview setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
