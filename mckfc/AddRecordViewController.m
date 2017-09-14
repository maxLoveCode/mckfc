//
//  AddRecordViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/5.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#define itemHeight 44
#import "AddRecordViewController.h"
#import "LoadingCell.h"
#import "ServerManager.h"
#import "CarPlateRegionSelector.h"
#import "MCPickerView.h"
#import "AlertHUDView.h"
//地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AddRecordViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,DatePickerDelegate,MCPickerViewDelegate,AMapSearchDelegate,MAMapViewDelegate,HUDViewDelegate>
{
    NSArray* titleArray;
    NSArray *_imgArray;
    NSArray* packageList;
    NSArray *_storageList;
    NSArray *_varietylist;
    NSString *_estimatedTime;
//    AMapSearchAPI *_search;
}

@property (nonatomic, strong) ServerManager* server;
//@property (nonatomic, strong) AMapLocationManager *locationManager;
//@property (nonatomic,strong) AMapPath* path;
@property (nonatomic, strong) AlertHUDView* alert;
@end

@implementation AddRecordViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    self.timeFlag = @"0";
}

-(AlertHUDView *)alert
{
    if (!_alert) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStyleBool];
        _alert.title.text = @"预计到达时间";
        _alert.delegate = self;
    }
    return _alert;
}

-(AddRecordTable *)tableView
{
    if (!_tableView) {
        _tableView = [[AddRecordTable alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        titleArray = @[@"运单号", @"车牌号", @"司机姓名", @"手机号码", @"土豆重量",@"计划到达时间",@"薯品种",@"存储期"];
        _imgArray = @[@"运单号", @"车牌号", @"司机姓名", @"手机号码", @"土豆重量",@"运输时间",@"土豆重量",@"土豆重量"];
        
        if (!_user) {
            _user = [[User alloc] init];
        }
        if (!_stats) {
            _stats = [[LoadingStats alloc] init];
        }
        if (_stats.departuretime) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"HH:mm"];
            NSDateFormatter* formatter3 = [[NSDateFormatter alloc] init];
            [formatter3 setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *newDate =  [NSDate date];
            NSString *time = [formatter2 stringFromDate: newDate];
            NSString *date = [formatter stringFromDate: _stats.departuretime];
            NSString *dateAndTimeStr = [NSString stringWithFormat:@"%@ %@",date,time];
            NSDate *dateAndTime = [formatter3 dateFromString:dateAndTimeStr];
            
            _stats.departuretime = dateAndTime;
        }
       
        _stats.planarrivetime = [NSDate dateWithTimeInterval:60 * 60 sinceDate:[NSDate date]];

        _server = [ServerManager sharedInstance];
    }
    return _tableView;
}

-(MCDatePickerView *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[MCDatePickerView alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return itemHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell* cell = [[LoadingCell alloc] init];
    if (indexPath.row == 0){
        cell.style = LoadingCellStyleTextInput;
        cell.textInput.delegate = self;
        cell.textInput.tag = 4;
        cell.textInput.textAlignment = NSTextAlignmentRight;
        cell.textInput.keyboardType = UIKeyboardTypePhonePad;
        cell.textInput.textColor = COLOR_WithHex(0x565656);
        
        //cell.textInput.text = _stats.serialno;
        UILabel *lab = [cell viewWithTag:11];
        if (lab.tag != 11) {
            
            lab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 200, 0, 50, 40)];
            lab.text = @"17  +";
            lab.font = [UIFont systemFontOfSize:16];
            lab.tag = 11;
            [cell.contentView addSubview:lab];
        }
        
        if (!_stats.serialno) {
            cell.textInput.textColor = COLOR_TEXT_GRAY;
            cell.textInput.text = @"请填写4位运单号";
        }else{
            if ([_stats.serialno length] >5) {
                NSString *serialno = [_stats.serialno substringFromIndex:2];
                cell.textInput.text = serialno;
            }else{
                cell.textInput.text = _stats.serialno;
            }
            
        }
        if ( self.serialnoEnable == YES) {
            cell.textInput.enabled = NO;
        }else{
            cell.textInput.enabled = YES;
        }
        [cell.textInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }else if (indexPath.row == 1) {
        
        cell.style = LoadingCellStyleCarPlateInput;
        [cell.popUpBtn addTarget:self action:@selector(popUpRegions:) forControlEvents:UIControlEventTouchUpInside];
        if (!_user.region || [_user.region isEqualToString:@""]) {
            [cell.popUpBtn setTitle:@"选择省份" forState: UIControlStateNormal];
        }
        else
        {
            [cell.popUpBtn setTitle:_user.region forState:UIControlStateNormal];
            [cell.popUpBtn setTitleColor:COLOR_WithHex(0x565656) forState:UIControlStateNormal];
        }
        cell.textInput.delegate = self;
        cell.textInput.tag = 0;
        cell.textInput.textColor = COLOR_WithHex(0x565656);
        cell.textInput.text = _user.cardigits;
        if (!_user.cardigits) {
            cell.textInput.textColor = COLOR_TEXT_GRAY;
            cell.textInput.text = @"请填写车牌号";
        }
        cell.textInput.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if(indexPath.row == 2){
        cell.style = LoadingCellStyleTextInput;
        cell.textInput.delegate = self;
        cell.textInput.tag = 1;
        cell.textInput.textColor = COLOR_WithHex(0x565656);
        cell.textInput.textAlignment = NSTextAlignmentRight;
        cell.textInput.text = _user.driver;
        if (!_user.driver) {
            cell.textInput.textColor = COLOR_TEXT_GRAY;
            cell.textInput.text = @"请填写司机姓名";
        }
    }
    else if(indexPath.row == 3){
        cell.style = LoadingCellStyleTextInput;
        cell.textInput.delegate = self;
        cell.textInput.tag = 2;
        cell.textInput.textAlignment = NSTextAlignmentRight;
        cell.textInput.keyboardType = UIKeyboardTypePhonePad;
        cell.textInput.textColor = COLOR_WithHex(0x565656);
        cell.textInput.text = _user.mobile;
        if (!_user.mobile) {
            cell.textInput.textColor = COLOR_TEXT_GRAY;
            cell.textInput.text = @"请填写司机手机号";
        }
    }
    else if(indexPath.row == 4){
        cell.style = LoadingCellStyleDigitInput;
        cell.digitInput.tag = 3;
        cell.digitInput.textAlignment = NSTextAlignmentRight;
        cell.digitInput.delegate = self;
        cell.digitInput.text = [NSString stringWithFormat:@"%@", _stats.weight];
    }
    else if(indexPath.row == 5){
        cell.style =LoadingCellStyleDatePicker;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSLog(@"++++++%@", [dateFormatter stringFromDate:_stats.planarrivetime]);
        cell.detailLabel.text = [dateFormatter stringFromDate:_stats.planarrivetime];
    }else if (indexPath.row == 6){
        cell.style =LoadingCellStyleSelection;
        if (!_stats.variety) {
            cell.detailLabel.text = @"请选择薯品种";
            cell.detailLabel.textColor = COLOR_TEXT_GRAY;
        }
        else
        {
            cell.detailLabel.textColor = COLOR_WithHex(0x565656);
            cell.detailLabel.text = _stats.variety.name;
        }
    }else if (indexPath.row == 7) {
        cell.style =LoadingCellStyleSelection;
        if (!_stats.storage) {
            cell.detailLabel.text = @"请选择存储期";
            cell.detailLabel.textColor = COLOR_TEXT_GRAY;
        }
        else
        {
            cell.detailLabel.textColor = COLOR_WithHex(0x565656);
            cell.detailLabel.text = _stats.storage.name;
        }
    }
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 5)
    {
         self.timeFlag = @"1";
        if (_planeDuration && _planeDuration > 0) {
             [self initComputeTime];
        }else{
             [self.delegate requestDate:self];
       }
      
       
        /*
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
         */
        
    } else if (indexPath.row == 6){
         //[self.delegate requestDate:self];
        if (!_varietylist || [_varietylist count] == 0) {
            [self requestVarietyListSuccess:^{
                MCPickerView *pickerView = [[MCPickerView alloc] init];
                pickerView.delegate = self;
                [pickerView setData:_varietylist];
                pickerView.index = indexPath;
                [pickerView show];
                _stats.variety = _varietylist[0];
                [self.tableView reloadData];
            }];
        }
        else
        {
            MCPickerView *pickerView = [[MCPickerView alloc] init];
            pickerView.delegate = self;
            [pickerView setData:_varietylist];
            pickerView.index = indexPath;
            [pickerView show];
            _stats.variety = _varietylist[0];
            [self.tableView reloadData];
        }

    }else if (indexPath.row == 7){
        // [self.delegate requestDate:self];
        if (!_storageList || [_storageList count] == 0) {
            [self requestStorageListSuccess:^{
                MCPickerView *pickerView = [[MCPickerView alloc] init];
                pickerView.delegate = self;
                [pickerView setData:_storageList];
                pickerView.index = indexPath;
                [pickerView show];
                
                _stats.storage = _storageList[0];
                [self.tableView reloadData];
            }];
        }
        else
        {
            MCPickerView *pickerView = [[MCPickerView alloc] init];
            pickerView.delegate = self;
            [pickerView setData:_storageList];
            pickerView.index = indexPath;
            [pickerView show];
            
            _stats.storage = _storageList[0];
            [self.tableView reloadData];
        }
        
    }
}

#pragma mark popUp menu
-(void)popUpRegions:(id)sender
{
    [_server GET:@"getRegionList"
      parameters:@{@"token":_server.accessToken}
        animated:YES
         success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
             CarPlateRegionSelector* selector = [[CarPlateRegionSelector alloc] init];
             [selector setRegions:responseObject[@"data"]];
             [selector show];
             
             //return block
             __weak User* weakref = self.user;
             __weak UIButton* weakbtn = sender;
             [selector setSelectBlock:^(NSString *result) {
                 
                 weakref.region = result;
                 weakref.truckno = [NSString stringWithFormat:@"%@%@", weakref.region, weakref.cardigits];
                 [weakbtn setTitleColor:COLOR_WithHex(0x565656) forState:UIControlStateNormal];
                 [_tableView reloadData];
             }];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
    }];
}

#pragma mark- textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

        textField.text = @"";
    [self.delegate addRecordView:self.tableView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate endEditing:self.tableView];
    switch (textField.tag) {
        case 0:
            _user.cardigits = textField.text;
            
            _user.truckno = [NSString stringWithFormat:@"%@%@", _user.region, _user.cardigits];
            break;
        case 1:
            _user.driver = textField.text;
            break;
        case 2:
            _user.mobile = textField.text;
            break;
        case 3:
            _stats.weight =
                [NSNumber numberWithFloat:[textField.text floatValue]];
            break;
        case 4:
            if ([textField.text length] > 5) {
                [_stats setSerialno:[NSString stringWithFormat:@"%@",textField.text]];
            }else if([textField.text length] == 4){
                [_stats setSerialno:[NSString stringWithFormat:@"17%@",textField.text]];
            }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark datePicker delegate
-(void)datePickerViewDidSelectDate:(NSDate *)date
{
    if (self.timeFlag && [self.timeFlag isEqualToString:@"0"]) {
        _stats.departuretime = date;
    }else{
        _stats.planarrivetime = date;
    }
    [self.tableView reloadData];
}


-(void)setDate:(NSDate*)date
{
    if(self.timeFlag && [self.timeFlag isEqualToString:@"0"]){
        [self.datePicker.picker setDate:date];
        [self.datePicker.picker setMinimumDate:date];
        [self.datePicker.picker setMaximumDate:[NSDate dateWithTimeInterval:24*60*60-1 sinceDate:date]];
    }else{
        [self.datePicker.picker setDate:[NSDate dateWithTimeInterval:60*60 sinceDate:[NSDate date]]];
        [self.datePicker.picker setMinimumDate:[NSDate dateWithTimeInterval:60*60 sinceDate:[NSDate date]]];
        [self.datePicker.picker setMaximumDate:nil];
    }
    
}

-(void)setUser:(User *)user
{
    self->_user = user;
    [self.tableView reloadData];
}

-(void)setStats:(LoadingStats *)stats
{
    self->_stats = stats;
    [self.tableView reloadData];
}

#pragma mark - web data requests
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

-(void)requestStorageListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getStorageList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        _storageList = [MTLJSONAdapter modelsOfClass:[Storage class] fromJSONArray:jsonArray error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _stats.storage = _storageList[0];
        if (_storageList) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestVarietyListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getVarietyList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        _varietylist = [MTLJSONAdapter modelsOfClass:[Variety class] fromJSONArray:jsonArray error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        _stats.variety = _varietylist[0];
        if (_varietylist) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - MCPickerView delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath *indexPath = pickerView.index;
    if (indexPath.row ==5){
        /*
        Package* pkg = packageList[row];
        _stats.package = pkg;
        [self.tableView reloadData];
         */
    } else if (indexPath.row == 6) {
        Variety *var = _varietylist[row];
        _stats.variety = var;
        [self.tableView reloadData];
    }else if (indexPath.row == 7) {
        Storage *stor = _storageList[row];
        _stats.storage = stor;
        [self.tableView reloadData];
    }
}

-(void)showDatePicker
{
    [self.datePicker show];
}

- (void) textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 4) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}

#pragma mark -- 计算预计到达时间
- (void)initComputeTime{
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        double spendTime = _planeDuration * 3600;
        NSString *hour = [NSString stringWithFormat:@"%.2f",spendTime / 3600];
        NSDate* estimate = [NSDate dateWithTimeInterval:spendTime sinceDate:_stats.departuretime];
    
        NSString *string = [dateFormatter stringFromDate:estimate];
    
    
        self.alert.title.text = @"预计到达时间";
        self.alert.detail.text = [NSString stringWithFormat:@"在途时间为%@小时，预计到达时间为%@，是否确定采用建议时间",hour,string] ;
        _estimatedTime = string;
        [self.alert show:self.alert];
        NSLog(@"结束-----time = %@",string);
}

#pragma mark ----- 地图定位计算时间

//- (void)initComputeTime{
//    NSLog(@"开始------");
//    [AMapServices sharedServices].apiKey = MapKey;
//    self.locationManager = [[AMapLocationManager alloc] init];
//    
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    //   定位超时时间，最低2s，此处设置为2s
//    self.locationManager.locationTimeout =2;
//    //   逆地理请求超时时间，最低2s，此处设置为2s
//    self.locationManager.reGeocodeTimeout = 2;
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
//    //   定位超时时间，最低2s，此处设置为10s
//    self.locationManager.locationTimeout =5;
//    //   逆地理请求超时时间，最低2s，此处设置为10s
//    self.locationManager.reGeocodeTimeout = 5;
//    
//    _search = [[AMapSearchAPI alloc] init];
//    _search.delegate = self;
//    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
//    
//    navi.requireExtension = YES;
//    navi.strategy = 5;
//    /* 目的地. */
//    if (!self.terminateLongtitude || !self.terminateLatitude) {
//        self.timeFlag = @"1";
//        [self.delegate requestDate:self];
//        return;
//    }
//    navi.destination = [AMapGeoPoint locationWithLatitude:[self.terminateLatitude doubleValue]
//                                                longitude:[self.terminateLongtitude doubleValue]];
//    
//    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//            
//            if (error.code == AMapLocationErrorLocateFailed)
//            {
//                self.timeFlag = @"1";
//                [self.delegate requestDate:self];
//                return;
//            }
//        }
//        
//        NSLog(@"location:%@", location);
//        NSLog(@"本地定位");
//        /* 出发点. */
//        navi.origin = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//
//        [_search AMapDrivingRouteSearch:navi];
//        
//        if (regeocode)
//        {
//           // NSLog(@"reGeocode:%@", regeocode);
//           
//        }
//    }];
//    
//}
//
///* 路径规划搜索回调. */
//- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
//{
//    if (response.route == nil)
//    {
//        self.timeFlag = @"1";
//        [self.delegate requestDate:self];
//        return;
//    }
//    
//    //解析response获取路径信息，具体解析见 Demo
//    _path = [response.route.paths objectAtIndex:0];
//    //delegate to parent view controller
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSTimeInterval interval = (double)_path.duration;
//    double spendTime = interval * 1.4;
//    NSString *hour = [NSString stringWithFormat:@"%.2f",spendTime / 3600];
//    NSDate* estimate = [NSDate dateWithTimeIntervalSinceNow: spendTime];
//    
//    NSString *string = [dateFormatter stringFromDate:estimate];
//    
//    
//    self.alert.title.text = @"预计到达时间";
//    self.alert.detail.text = [NSString stringWithFormat:@"以每小时40千米行驶，在途时间为%@小时，预计到达时间为%@，是否确定采用建议时间%@",hour,string,string] ;
//    _estimatedTime = string;
//    [self.alert show:self.alert];
//    NSLog(@"结束-----time = %@",string);
//}
//
//- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
//{
//    NSLog(@"Error: %@", error);
//    
//}
//
//- (void)didSelectConfirm{
//    [self.alert removeFromSuperview];
//}
#pragma mark -alertview delegate
-(void)didSelectConfirm
{
    if (_estimatedTime) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _stats.planarrivetime = [dateFormatter dateFromString:_estimatedTime];
        [_tableView reloadData];
    }
  
    [self.alert removeFromSuperview];
    
}

- (void)didCancleClick{
    self.timeFlag = @"1";
    [self.delegate requestDate:self];

}

@end
