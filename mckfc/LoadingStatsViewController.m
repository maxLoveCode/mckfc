//
//  LoadingStatsViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//  这个页面可能需要缓存
//  考虑到司机们开到荒山野外的沟沟里面

//  装载页面

#import "LoadingStatsViewController.h"
#import "TranspotationPlanViewController.h"
#import "LoadingCell.h"

#import "MCPickerView.h"
#import "MCDatePickerView.h"
#import "AlertHUDView.h"

//models
#import "TransportDetail.h"

#import "ServerManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define itemHeight 44
#define topMargin 60
#define buttonHeight 40
#define buttonWidth kScreen_Width-4*k_Margin

@interface LoadingStatsViewController ()<MCPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate, DatePickerDelegate,HUDViewDelegate>
{
    NSDateFormatter *dateFormatter;
    NSArray* titleText;
    
    NSArray* vendorList;
    NSArray* cityList;
    NSArray* fieldList;
    NSArray* packageList;
    NSArray* factoryList;
    
    NSString* citycode;
}

@property (nonatomic, strong) MCPickerView* pickerView;
@property (nonatomic, strong) AlertHUDView* alert;

@property (nonatomic, strong) ServerManager* server;

@property (nonatomic, strong) AMapLocationManager* locationManager;

@end

@implementation LoadingStatsViewController

-(void)viewDidLoad
{
    self.title = @"装载数据";
    
    [self.tableView registerClass:[LoadingCell class] forCellReuseIdentifier:@"loadingStats"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (!_stats) {
        _stats = [[LoadingStats alloc] init];
    }
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _server = [ServerManager sharedInstance];
    
    [AMapServices sharedServices].apiKey = MapKey;
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self initTitlesAndImages];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self locating];
}

#pragma mark titles and images
-(void)initTitlesAndImages
{
    titleText = @[@"供应商名称",@"地块编号",@"工厂名称",@"土豆重量", @"发车时间", @"运单号", @"包装类型"];
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return itemHeight;
    }
    else if(indexPath.section ==1){
        return itemHeight*2;
    }
    else
        return kScreen_Height-itemHeight*6-60-66-20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [titleText count];
    }
    else if(section == 1)
    {
        return 1;
    }
    else
        return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LoadingCell* cell = [[LoadingCell alloc] init];
        
        if (indexPath.row != 3 && indexPath.row != 4 && indexPath.row != 5) {
            [cell setStyle:LoadingCellStyleSelection];
            if (indexPath.row == 0) {
                if (!_stats.supplier) {
                    cell.detailLabel.text = @"请选择供应商";
                }
                else
                    cell.detailLabel.text = _stats.supplier.name;
            }
            else if (indexPath.row ==1){
                if (!_stats.field) {
                    cell.detailLabel.text = @"请选择地块";
                }
                else
                    cell.detailLabel.text = _stats.field.name;
            }
            else if(indexPath.row == 2)
            {
                if (!_stats.factory) {
                    cell.detailLabel.text = @"请选择工厂";
                }
                else
                    cell.detailLabel.text = _stats.factory.name;
            }
            else if(indexPath.row == 6)
            {
                if (!_stats.package) {
                    cell.detailLabel.text = @"请选择包装类型";
                }
                else
                    cell.detailLabel.text = _stats.package.name;
            }
        }
        else if(indexPath.row == 3)
        {
            [cell setStyle:LoadingCellStyleDigitInput];
            cell.digitInput.delegate = self;
            if (!_stats.weight) {
                cell.digitInput.text = @"0";
            }
            else
            {
                cell.digitInput.text = [NSString stringWithFormat:@"%@",_stats.weight];
            }
        }
        else if(indexPath.row == 4)
        {
            [cell setStyle:LoadingCellStyleDatePicker];
            if(!_stats.departuretime)
            {
                cell.detailLabel.text = @"请选择时间";
            }
            else
            {
                cell.detailLabel.text = [dateFormatter stringFromDate:_stats.departuretime];
            }
        }
        else if(indexPath.row == 5)
        {
            [cell setStyle:LoadingCellStyleTextInput];
            cell.textInput.textAlignment = NSTextAlignmentRight;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textInput.tag = 1;
            cell.textInput.delegate = self;
            cell.textInput.keyboardType = UIKeyboardTypeNumberPad;
            cell.textInput.textColor = COLOR_WithHex(0x565656);
            if (!_stats.serialno || [_stats.serialno isEqualToString:@""]) {
                cell.textInput.text = @"请输入运单号";
            }
            else
                cell.textInput.text = _stats.serialno;
        }
        cell.titleLabel.text = titleText[indexPath.row];
        cell.leftImageView.image = [UIImage imageNamed:titleText[indexPath.row]];
        return cell;
    }
    else if(indexPath.section ==1){
        LoadingCell* cell = [[LoadingCell alloc] init];
        NSString* title = @"其他情况说明";
        [cell setStyle:LoadingCellStyleTextField];
        cell.titleLabel.text = title;
        cell.leftImageView.image = [UIImage imageNamed:title];
        cell.textField.delegate  = self;
        cell.textField.text = _stats.extraInfo;
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        UIButton* confirm;
        confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:@"进行装载" forState:UIControlStateNormal];
        [confirm setBackgroundColor:COLOR_THEME];
        [confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        confirm.layer.cornerRadius = 3;
        confirm.layer.masksToBounds = YES;
        [confirm setFrame:CGRectMake(2*k_Margin, topMargin,buttonWidth , buttonHeight)];
        [confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:confirm];
        return cell;
    }
}

#pragma mark UITableview selection delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LoadingCell* cell = [tableView cellForRowAtIndexPath:indexPath];
  
    if (cell.style == LoadingCellStyleSelection){
        if (indexPath.row == 0) {
            if (!cityList) {
                [self requestCityListSuccess:^{
                    City* city = [cityList objectAtIndex:0];
                    [self requestVendors:city.cityid success:^{
                        MCPickerView *pickerView = [[MCPickerView alloc] init];
                        pickerView.delegate =self;
                        pickerView.index = indexPath;
                        [pickerView setGreaterOrderData:cityList];
                        [pickerView setData:vendorList];
                        [pickerView show];
                        
                        Vendor* vendor = vendorList[0];
                        _stats.supplier = vendor;
                        
                        [self.tableView reloadData];
                    }];
                }];
            }
            else
            {
                City* city = [cityList objectAtIndex:0];
                [self requestVendors:city.cityid success:^{
                    MCPickerView *pickerView = [[MCPickerView alloc] init];
                    pickerView.delegate =self;
                    pickerView.index = indexPath;
                    [pickerView setGreaterOrderData:cityList];
                    [pickerView setData:vendorList];
                    
                    [pickerView show];
                    
                    if (!_stats.supplier) {
                        Vendor* vendor = vendorList[0];
                        _stats.supplier = vendor;
                        
                        [self.tableView reloadData];
                    }
                }];

            }
        }
        else if(indexPath.row == 1)
        {
            Vendor* vendor = _stats.supplier;
            if (!vendor) {
                if (!_alert) {
                    _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
                    _alert.delegate = self;
                }
                self.alert.title.text = @"错误";
                self.alert.detail.text = @"请先选择供应商";
                [self.alert show:self.alert];
            }
            else
            {
                [self requestFields:[NSString stringWithFormat:@"%lu", (long)vendor.vendorID]
                               City:_stats.city.cityid
                            success:^{
                                if(!self.pickerView)
                                {
                                    self.pickerView = [[MCPickerView alloc] init];
                                    self.pickerView.delegate = self;
                                    self.pickerView.index = indexPath;
                                }
                                [self.pickerView setData:fieldList];
                                [self.pickerView show];
                                _stats.field = fieldList[0];
                                [self.tableView reloadData];
                    }];
            }
        }
        
        else if(indexPath.row == 2)
        {
            if (!factoryList || [factoryList count] == 0) {
                [self requestFactoryListSuccess:^{
                    MCPickerView *pickerView = [[MCPickerView alloc] init];
                    pickerView.delegate = self;
                    [pickerView setData:factoryList];
                    pickerView.index = indexPath;
                    [pickerView show];
                    
                    _stats.factory = factoryList[0];
                    [self.tableView reloadData];
                }];
            }
            else
            {
                MCPickerView *pickerView = [[MCPickerView alloc] init];
                pickerView.delegate = self;
                [pickerView setData:factoryList];
                pickerView.index = indexPath;
                [pickerView show];
                
                _stats.factory = factoryList[0];
                [self.tableView reloadData];
            }
        }
        else if(indexPath.row == 6)
        {
            if (!packageList || [packageList count] == 0) {
                [self requestPackageListSuccess:^{
                    MCPickerView *pickerView = [[MCPickerView alloc] init];
                    pickerView.delegate = self;
                    [pickerView setData:packageList];
                    pickerView.index = indexPath;
                    [pickerView show];
                    
                    _stats.package = packageList[0];
                    [self.tableView reloadData];
                }];
            }
            else
            {
                MCPickerView *pickerView = [[MCPickerView alloc] init];
                pickerView.delegate = self;
                [pickerView setData:packageList];
                pickerView.index = indexPath;
                [pickerView show];
                
                _stats.package = packageList[0];
                [self.tableView reloadData];
            }
        }
    }
    else if(cell.style == LoadingCellStyleDatePicker)
    {
        MCDatePickerView* datePicker = [[MCDatePickerView alloc] init];
        datePicker.delegate = self;
        [datePicker show];
        
        if(!_stats.departuretime)
        {
            _stats.departuretime = datePicker.picker.date;
        }
            
    }
    
    [tableView reloadData];
}

#pragma mark headerview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
        [bgView setBackgroundColor:COLOR_WithHex(0xfbeeae)];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, 30)];
        label.text = @"公告：请各位司机严格把握运输时间";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = COLOR_WithHex(0xff9517);
        [bgView addSubview:label];
        return bgView;
    }
    else if (section == 1){
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight)];
        [bgView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, itemHeight)];
        label.text = @"发车时间直接影响运输计划的时间安排，时间填写错误可能导致无法正常卸货，请仔细填写";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor redColor];
        label.numberOfLines = 0;
        [bgView addSubview:label];
        return bgView;
    }
    return nil;
}

#pragma header view and footers
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0 ) {
        return 30;
    }
    else if(section ==1)
    {
        return itemHeight;
    }
    else
        return tableView.sectionHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - POST loading stats check correctness
-(void)confirmBtn
{
    [self dismiss];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"token":_server.accessToken} copyItems:YES];
    if (_stats.supplier) {
        [params addEntriesFromDictionary:@{@"vendorid":[NSString stringWithFormat:@"%lu",(unsigned long)_stats.supplier.vendorID]}];
    }
    if (_stats.field) {
        [params addEntriesFromDictionary:@{@"fieldid":[NSString stringWithFormat:@"%lu",(unsigned long)_stats.field.fieldID]}];
    }
    if (_stats.weight) {
        [params addEntriesFromDictionary:@{@"weight":[NSString stringWithFormat:@"%@",_stats.weight]}];
    }
    if (_stats.departuretime) {
        [params addEntriesFromDictionary:@{@"departuretime":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_stats.departuretime]]}];
    }
    if (_stats.extraInfo) {
        [params addEntriesFromDictionary:@{@"remark":_stats.extraInfo}];
    }
    if (_stats.serialno) {
        [params addEntriesFromDictionary:@{@"serialno":_stats.serialno}];
    }
    if (_stats.package) {
        [params addEntriesFromDictionary:@{@"packageid":_stats.package.packageid}];
    }
    if (_stats.factory) {
        [params addEntriesFromDictionary:@{@"factoryid":_stats.factory.factoryid}];
    }
    NSLog(@"%@", params);
    [_server POST:@"transport" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        TransportDetail* detail = [[TransportDetail alloc] initWithID:[data[@"transportid"] integerValue]];
        NSLog(@"%@", detail);
        TranspotationPlanViewController *plan = [[TranspotationPlanViewController alloc] initWithStyle:UITableViewStylePlain];
        plan.detail = detail;
        [self.navigationController pushViewController:plan animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - MCPickerView delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath *indexPath = pickerView.index;
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            NSInteger components = [pickerView.picker numberOfComponents];
            if (component != components-1) { // not the last component
                City* selectedCity = [cityList objectAtIndex:row];
                [self requestVendors:selectedCity.cityid success:^{
                    [pickerView setData:vendorList];
                    [pickerView.picker reloadComponent:component+1];
                    Vendor* vendor = vendorList[0];
                    _stats.supplier = vendor;
                    _stats.city = selectedCity;
                    [self.tableView reloadData];
                }];
            }
            else
            {
                Vendor* vendor = vendorList[row];
                _stats.supplier = vendor;
                [self.tableView reloadData];
            }
        }
        else if (indexPath.row ==1){
            Field* field = fieldList[row];
            _stats.field = field;
            [self.tableView reloadData];
        }
        else if (indexPath.row ==2){
            Factory* factory = factoryList[row];
            _stats.factory = factory;
            [self.tableView reloadData];
        }
        else if (indexPath.row ==6){
            Package* pkg = packageList[row];
            _stats.package = pkg;
            [self.tableView reloadData];
        }
    }
}

#pragma mark uitextview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        _stats.extraInfo = textView.text;
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [_stats setExtraInfo:textView.text];
    NSLog(@"%@",_stats.extraInfo);
}

#pragma mark textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = item;
    if ([textField.text isEqualToString:@"0"] ||[textField.text isEqualToString:@"请输入运单号"] ) {
        textField.text = @"";
    }
}

-(void)dismiss
{
   // LoadingCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        [_stats setWeight:[NSNumber numberWithFloat:[textField.text floatValue]]];
    }
    else
    {
        [_stats setSerialno:textField.text];
    }
}

#pragma mark datePicker delegate
-(void)datePickerViewDidSelectDate:(NSDate *)date
{
    _stats.departuretime = date;
    [self.tableView reloadData];
}

#pragma mark - web data requests
-(void)requestCityListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getCityList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        cityList = [MTLJSONAdapter modelsOfClass:[City class] fromJSONArray:jsonArray error:&error];
        if (error) {
            
        }
        _stats.city = cityList[0];
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
        NSLog(@"%@",data);
        NSError* error;
        vendorList = [MTLJSONAdapter modelsOfClass:[Vendor class] fromJSONArray:data error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
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
                             @"city":cityid};
    [_server GET:@"getFieldList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* data = responseObject[@"data"];
        fieldList = [MTLJSONAdapter modelsOfClass:[Field class] fromJSONArray:data error:nil];
        NSLog(@"%@",data);
        if (fieldList && [fieldList count] >0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestPackageListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getPackageList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        packageList = [MTLJSONAdapter modelsOfClass:[Package class] fromJSONArray:jsonArray error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _stats.package = packageList[0];
        if (packageList) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestFactoryListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getFactoryList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        factoryList = [MTLJSONAdapter modelsOfClass:[Factory class] fromJSONArray:jsonArray error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _stats.factory = factoryList[0];
        if (factoryList || [factoryList count] != 0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - alerts
-(void)didSelectConfirm
{
    [_alert removeFromSuperview];
}

-(void)setStats:(LoadingStats *)stats
{
    self->_stats = stats;
    [self.tableView reloadData];
}

-(void)locating
{
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为3s
    self.locationManager.locationTimeout =3;
    //   逆地理请求超时时间，最低2s，此处设置为3s
    self.locationManager.reGeocodeTimeout = 3;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的YES改成NO，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        
        if (regeocode)
        {
            citycode = regeocode.citycode;
            if (!cityList) {
                [self requestCityListSuccess:^{
                    for (City* city in cityList) {
                        if ([city.cityid isEqualToString:citycode]) {
                            _stats.city = city;
                            NSMutableArray* sort = [[NSMutableArray alloc] initWithArray:cityList];
                            [sort removeObject:city];
                            [sort insertObject:city atIndex:0];
                            cityList = sort;
                            return;
                        }
                    }
                }];
            }
        }
    }];
}
@end
