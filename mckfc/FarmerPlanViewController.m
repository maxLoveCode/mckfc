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

#import "ServerManager.h"

#import "Vendor.h"
#import "City.h"
#import "Field.h"


#define buttonHeight 40

@interface FarmerPlanViewController ()<FarmerPlanViewDelegate, MCPickerViewDelegate>
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

@end

@implementation FarmerPlanViewController

-(void)viewDidLoad
{
    self.view = self.farmerPlanview;
    
    _server = [ServerManager sharedInstance];
}

-(FarmerPlanView *)farmerPlanview
{
    if (!_farmerPlanview) {
        _farmerPlanview = [[FarmerPlanView alloc] init];
        _farmerPlanview.delegate = self;
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

-(void)menu:(FarmerPlanView *)Menu DidSelectIndex:(NSInteger)index
{
    NSLog(@"%ld", (long)index);
    
    if (index == 0) {
        _farmerPlanview.type = FarmerPlanViewTypeQRCode;
        _QRVC = [[FarmerQRCodeVC alloc] init];
        [self addChildViewController:_QRVC];
        _farmerPlanview.qrCodeView = (FarmerQRCodeView*)_QRVC.view;
        [self reload];
    }
    else if (index == 1)
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self.botButton];
        
        _farmerPlanview.type = FarmerPlanViewTypeOrder;
        _addRecordVC = [[AddRecordViewController alloc] init];
        [self addChildViewController:_addRecordVC];
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

-(void)tableStats:(UITableView *)table DidSelectIndex:(NSInteger)index
{
    if (index == 0) {
        self.pickerView.index = [NSIndexPath indexPathForRow:index inSection:0];
        
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
        if (cityList == nil || [cityList count] == 0) {
            [self requestCityListSuccess:^{
                [self.pickerView setData:cityList];
                [self.pickerView show];
            }];
        }
        else
        {
            [self.pickerView setData:cityList];
            [self.pickerView show];
        }
    }
    else if (index == 2){
        if (cityList == nil || [cityList count] == 0) {
            [self requestCityListSuccess:^{
                [self.pickerView setData:cityList];
                [self.pickerView show];
            }];
        }
        else
        {
            [self.pickerView setData:cityList];
            [self.pickerView show];
        }
    }
    else if (index == 3){
        
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

#pragma mark web data requests
-(void)requestCityListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getCityList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
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

#pragma mark MCPickerView delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //select city
    if (pickerView.index.row == 0) {
        _farmerPlanview.stats.city = cityList[row];
        [self reload];
    }
}

#pragma mark reload shorthand
-(void)reload
{
    [_farmerPlanview.mainTableView reloadData];
}


@end
