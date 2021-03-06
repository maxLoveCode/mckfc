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

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define itemHeight 44
#define topMargin 60
#define buttonHeight 40
#define buttonWidth kScreen_Width-4*k_Margin

@interface LoadingStatsViewController ()<MCPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate, DatePickerDelegate,HUDViewDelegate,AMapSearchDelegate,MAMapViewDelegate>
{
    NSDateFormatter *dateFormatter;
    NSArray* titleText;
    NSArray *_imgArray;
    
    NSArray* vendorList;
    NSArray* cityList;
    NSArray* fieldList;
    NSArray* packageList;
    NSArray *_storageList;
    NSArray *_varietylist;
    NSArray* factoryList;
    
    NSString* citycode;
    
    NSString *_estimatedTime;
    double _planeDuration;
    //AMapSearchAPI *_search;
}

@property (nonatomic, strong) MCPickerView* pickerView;
@property (nonatomic, strong) AlertHUDView* alert;

@property (nonatomic, strong) AlertHUDView* alertPlan;
@property (nonatomic, strong) ServerManager* server;

@property (nonatomic, strong) AMapLocationManager* locationManager;
@property (nonatomic, strong) MCDatePickerView *datePicker;
@property (nonatomic,copy) NSString *timeFlag;

//@property (nonatomic, strong) NSNumber *terminateLongtitude;
//@property (nonatomic, strong) NSNumber *terminateLatitude;
@property (nonatomic, assign) BOOL planTimeAndOther;

@property (nonatomic,strong) AMapPath* path;

@end

@implementation LoadingStatsViewController

-(void)viewDidLoad
{
    self.title = @"装载数据";
    self.timeFlag = @"0";
    self.planTimeAndOther = NO;
    [self.tableView registerClass:[LoadingCell class] forCellReuseIdentifier:@"loadingStats"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (!_stats) {
        _stats = [[LoadingStats alloc] init];
        _stats.planarrivetime = [NSDate dateWithTimeInterval:60 * 60 sinceDate:[NSDate date]];
    }
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _server = [ServerManager sharedInstance];
    
    [AMapServices sharedServices].apiKey = MapKey;
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self initTitlesAndImages];
}

-  (MCDatePickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [[MCDatePickerView alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}
-(AlertHUDView *)alertPlan
{
    if (!_alertPlan) {
        _alertPlan = [[AlertHUDView alloc] initWithStyle:HUDAlertStyleBool];
        _alertPlan.title.text = @"预计到达时间";
        _alertPlan.delegate = self;
    }
    return _alertPlan;
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
    titleText = @[@"运单号",@"供应商名称",@"地块编号",@"目的地",@"土豆重量",@"发货时间",@"预计到达时间",@"薯品种",@"存储期"];
    _imgArray = @[@"运单号",@"供应商名称",@"地块编号",@"目的地",@"土豆重量",@"发车时间",@"发车时间",@"包装类型",@"包装类型"];
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
        
        if (indexPath.row != 4  && indexPath.row != 0) {
            [cell setStyle:LoadingCellStyleSelection];
        }
            if (indexPath.row == 0) {
                [cell setStyle:LoadingCellStyleTextInput];
                cell.textInput.textAlignment = NSTextAlignmentRight;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textInput.tag = 1;
                cell.textInput.delegate = self;
                cell.textInput.keyboardType = UIKeyboardTypeNumberPad;
                cell.textInput.textColor = COLOR_WithHex(0x565656);
                UILabel *lab = [cell viewWithTag:11];
                if (lab.tag != 11) {
                    
                    lab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 200, 0, 50, 40)];
                    lab.text = @"17  +";
                    lab.font = [UIFont systemFontOfSize:16];
                    lab.tag = 11;
                    [cell.contentView addSubview:lab];
                }
                [cell.textInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                if (!_stats.serialno || [_stats.serialno isEqualToString:@""]) {
                    cell.textInput.text = @"请输入4位运单号";
                }
                else{
                    if ([_stats.serialno length] >5) {
                        NSString *serialno = [_stats.serialno substringFromIndex:2];
                        NSLog(@"0000000%@",serialno);
                        cell.textInput.text = serialno;
                    }else{
                        cell.textInput.text = _stats.serialno;
                    }
                }
                   
            }else if (indexPath.row == 1){
                if (!_stats.supplier) {
                    cell.detailLabel.text = @"请选择供应商";
                }
                else
                    cell.detailLabel.text = _stats.supplier.name;
            }else if (indexPath.row ==2){
                if (!_stats.field) {
                    cell.detailLabel.text = @"请选择地块";
                }
                else
                    cell.detailLabel.text = _stats.field.name;
            }
            else if(indexPath.row == 3)
            {
                if (!_stats.factory) {
                    cell.detailLabel.text = @"请选择工厂";
                }
                else{
                    cell.detailLabel.text = _stats.factory.name;
                }
        }else if(indexPath.row == 4)
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
       else if(indexPath.row == 5)
       {
           [cell setStyle:LoadingCellStyleDatePicker];
           if(!_stats.departuretime)
           {
               cell.detailLabel.text = @"请选择发货时间";
           }
           else
           {
               cell.detailLabel.text = [dateFormatter stringFromDate:_stats.departuretime];
           }
       }
        else if(indexPath.row == 6){
            [cell setStyle:LoadingCellStyleDatePicker];
            if(!_stats.planarrivetime)
            {
                cell.detailLabel.text = @"请选择到达时间";
            }
            else
            {
                cell.detailLabel.text = [dateFormatter stringFromDate:_stats.planarrivetime];
            }
        }else if (indexPath.row == 7){
            if (!_stats.variety) {
                cell.detailLabel.text = @"请选择薯品种";
            }
            else
                cell.detailLabel.text = _stats.variety.name;
        }else if(indexPath.row == 8){
            if (!_stats.storage) {
                cell.detailLabel.text = @"请选择存储期";
            }
            else
                cell.detailLabel.text = _stats.storage.name;
        }
        cell.titleLabel.text = titleText[indexPath.row];
        cell.leftImageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
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
        if (indexPath.row == 1) {
            if (!cityList) {
                [self requestCityListSuccess:^{
                    City* city = [cityList objectAtIndex:0];
                    [self requestVendors:city.areaid success:^{
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
                [self requestVendors:city.areaid success:^{
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
        else if(indexPath.row == 2)
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
                               City:_stats.city.areaid
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
        
        else if(indexPath.row == 3)
        {
            Field* field = _stats.field;
            //如果没有地块先选地块
            if (!field) {
                if (!_alert) {
                    _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
                    _alert.delegate = self;
                }
                self.alert.title.text = @"错误";
                self.alert.detail.text = @"请先选择地块";
                [self.alert show:self.alert];
            }
            else //加载网络
            {
                [self requestFactoryList:[NSString stringWithFormat:@"%lu", (long)field.fieldID] success:^{
                    MCPickerView *pickerView = [[MCPickerView alloc] init];
                    pickerView.delegate =self;
                    pickerView.index = indexPath;
                    [pickerView setData:factoryList];
                    [pickerView show];
                    if (!_stats.factory) {
                        _stats.factory = factoryList[0];
                    }
                    [self.tableView reloadData];
                }];
            }
        }
        else if(indexPath.row == 5)
        {
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
        }
        else if (indexPath.row == 7){
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
                
                _stats.package = _varietylist[0];
                [self.tableView reloadData];
            }
            
        }else if (indexPath.row == 8){
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
                
                _stats.package = _storageList[0];
                [self.tableView reloadData];
            }
            
        }
    }
    else if(cell.style == LoadingCellStyleDatePicker)
    {
        if(indexPath.row == 5){
            self.timeFlag = @"0";
            [self setDate:[NSDate date]];
            [_datePicker show];
        }else{
            self.timeFlag = @"1";
             [self setDate:[NSDate date]];
            if (_planeDuration && _planeDuration > 0) {
                self.planTimeAndOther = YES;
                [self initComputeTime];
            }else{
                self.planTimeAndOther = NO;
                 [_datePicker show];
            }
        
            self.planTimeAndOther = YES;
//            if (self.terminateLongtitude && self.terminateLatitude) {
//                [self initComputeTime];
//            }else{
//                self.timeFlag = @"1";
//                [datePicker show];
//            }
            
        }

        /*
        if(!_stats.departuretime)
        {
            _stats.departuretime = datePicker.picker.date;
        }
         */
            
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
    if(_stats.departuretime){
        [params addEntriesFromDictionary:@{@"departuretime":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_stats.departuretime]]}];
    }

    if (_stats.planarrivetime) {
        [params addEntriesFromDictionary:@{@"planarrivetime":[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_stats.planarrivetime]]}];
    }
    
    if (_stats.extraInfo) {
        [params addEntriesFromDictionary:@{@"remark":_stats.extraInfo}];
    }else{
       [params addEntriesFromDictionary:@{@"remark":@""}];
    }
    if (_stats.serialno) {
        if ([_stats.serialno length] > 5) {
             [params addEntriesFromDictionary:@{@"serialno":_stats.serialno}];
        }else{
            [params addEntriesFromDictionary:@{@"serialno":[NSString stringWithFormat:@"17%@",_stats.serialno]}];
           
        }
        
    }
    //if (_stats.package) {
        [params addEntriesFromDictionary:@{@"packageid":@1}];
   // }
    if (_stats.storage) {
        [params addEntriesFromDictionary:@{@"storageid":_stats.storage.storageid}];
    }
    if (_stats.variety) {
        [params addEntriesFromDictionary:@{@"varietyid":_stats.variety.varietyid}];
    }
    if (_stats.factory) {
        [params addEntriesFromDictionary:@{@"factoryid":_stats.factory.factoryid}];
    }
    NSLog(@"++++++%@", params);
    [_server POST:@"transport" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        TransportDetail* detail = [[TransportDetail alloc] initWithID:[data[@"transportid"] integerValue]];
        NSLog(@"%@", detail);
        if([responseObject[@"code"] integerValue] == 10000){
            TranspotationPlanViewController *plan = [[TranspotationPlanViewController alloc] initWithStyle:UITableViewStylePlain];
            plan.detail = detail;
            [self.navigationController pushViewController:plan animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - MCPickerView delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath *indexPath = pickerView.index;
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            NSInteger components = [pickerView.picker numberOfComponents];
            if (component != components-1) { // not the last component
                City* selectedCity = [cityList objectAtIndex:row];
                _planeDuration = [selectedCity.time doubleValue];
                [self requestVendors:selectedCity.areaid success:^{
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
        else if (indexPath.row ==2){
            Field* field = fieldList[row];
            _stats.field = field;
            [self.tableView reloadData];
        }
        else if (indexPath.row ==3){
            Factory* factory = factoryList[row];
            _stats.factory = factory;
//            self.terminateLatitude = factory.pointy;
//            self.terminateLongtitude = factory.pointx;
            [self.tableView reloadData];
        }
        else if (indexPath.row ==6){
            /*
            Package* pkg = packageList[row];
            _stats.package = pkg;
            [self.tableView reloadData];
             */
        }
        else if (indexPath.row == 7) {
            Variety *var = _varietylist[row];
            _stats.variety = var;
            [self.tableView reloadData];
        }else if (indexPath.row == 8) {
            Storage *stor = _storageList[row];
            _stats.storage = stor;
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
    if ([textField.text isEqualToString:@"0"] ||[textField.text isEqualToString:@"请输入4位运单号"] ) {
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
        if ([textField.text length] > 5) {
            [_stats setSerialno:[NSString stringWithFormat:@"%@",textField.text]];
        }else if([textField.text length] == 4){
            [_stats setSerialno:[NSString stringWithFormat:@"17%@",textField.text]];
        }
        
    }
}

#pragma mark datePicker delegate
-(void)datePickerViewDidSelectDate:(NSDate *)date
{
    if ([self.timeFlag isEqualToString:@"0"]) {
        _stats.departuretime = date;
    }else{
        _stats.planarrivetime = date;
    }
       // _stats.planarrivetime = date;
    [self.tableView reloadData];
}

#pragma mark - web data requests
-(void)requestCityListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getAreaList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSLog(@"---%@",jsonArray);
        NSError* error;
        cityList = [MTLJSONAdapter modelsOfClass:[City class] fromJSONArray:jsonArray error:&error];
        if (error) {
            
        }
        City *city = cityList[0];
        _planeDuration = [city.time doubleValue];
        _stats.city = cityList[0];
        if(cityList) {
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
                             @"areaid":cityid};
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
        _stats.factory = factoryList[0];
//        Factory *factory = factoryList[0];
//        self.terminateLatitude = factory.pointy;
//        self.terminateLongtitude = factory.pointx;
        
        if (factoryList || [factoryList count] != 0) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - alerts
//-(void)didSelectConfirm
//{
//    [_alert removeFromSuperview];
//}

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
                        if ([city.areaid isEqualToString:citycode]) {
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

- (void) textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 1) {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}

#pragma mark -- 计算预计到达时间
- (void)initComputeTime{
        double spendTime = _planeDuration *3600;
        NSString *hour = [NSString stringWithFormat:@"%.2f",spendTime / 3600];
    NSDate* estimate = [NSDate dateWithTimeInterval:spendTime sinceDate:_stats.departuretime];
    
        NSString *string = [dateFormatter stringFromDate:estimate];
    
    
        self.alertPlan.title.text= @"预计到达时间";
        self.alertPlan.detail.text = [NSString stringWithFormat:@"在途时间为%@小时，预计到达时间为%@，是否确定采用建议时间",hour,string] ;
        _estimatedTime = string;
        [self.alertPlan show:self.alertPlan];
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
//                MCDatePickerView* datePicker = [[MCDatePickerView alloc] init];
//                datePicker.delegate = self;
//                self.timeFlag = @"1";
//                [datePicker show];
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
//            // NSLog(@"reGeocode:%@", regeocode);
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
//        MCDatePickerView* datePicker = [[MCDatePickerView alloc] init];
//        datePicker.delegate = self;
//        self.timeFlag = @"1";
//        [datePicker show];
//        return;
//    }
//    
//    //解析response获取路径信息，具体解析见 Demo
//    _path = [response.route.paths objectAtIndex:0];
//    //delegate to parent view controller
////    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
////    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSTimeInterval interval = (double)_path.duration;
//    double spendTime = interval * 1.4;
//    NSString *hour = [NSString stringWithFormat:@"%.2f",spendTime / 3600];
//    NSDate* estimate = [NSDate dateWithTimeIntervalSinceNow: spendTime];
//    
//    NSString *string = [dateFormatter stringFromDate:estimate];
//    
//    
//    self.alertPlan.title.text = @"预计到达时间";
//    self.alertPlan.detail.text = [NSString stringWithFormat:@"以每小时40千米行驶，在途时间为%@小时，预计到达时间为%@，是否确定采用建议时间%@",hour,string,string] ;
//    _estimatedTime = string;
//    [self.alertPlan show:self.alertPlan];
//    NSLog(@"结束-----time = %@",string);
//}
//
//- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
//{
//    NSLog(@"Error: %@", error);
//    
//}
//
#pragma mark -alertview delegate
-(void)didSelectConfirm
{
    if (self.planTimeAndOther == YES) {
        if (_estimatedTime) {
            _stats.planarrivetime = [dateFormatter dateFromString:_estimatedTime];
            [self.tableView reloadData];
        }
        [self.alertPlan removeFromSuperview];
    }else{
        [self.alert removeFromSuperview];
    }
    
    self.planTimeAndOther = NO;
    
    
}

- (void)didCancleClick{
    self.timeFlag = @"1";
    [_datePicker show];
    self.planTimeAndOther = NO;
}

#pragma mark  -- 设置时间限制
-(void)setDate:(NSDate*)date
{
    if ([self.timeFlag isEqualToString:@"0"]) {
        [self.datePicker.picker setDate:date];
        [self.datePicker.picker setMinimumDate:date];
    }else{
        [self.datePicker.picker setDate:[NSDate dateWithTimeInterval:60*60 sinceDate:date]];
        [self.datePicker.picker setMinimumDate:[NSDate dateWithTimeInterval:60*60 sinceDate:date]];
        [self.datePicker.picker setMaximumDate:nil];
    }
    
    
}

@end
