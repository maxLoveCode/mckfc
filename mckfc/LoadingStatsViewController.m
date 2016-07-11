//
//  LoadingStatsViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//  这个页面可能需要缓存
//  考虑到司机们开到荒山野外的沟沟里面

#import "LoadingStatsViewController.h"
#import "TranspotationPlanViewController.h"
#import "LoadingCell.h"

#import "MCPickerView.h"
#import "MCDatePickerView.h"
#import "AlertHUDView.h"

//models
#import "LoadingStats.h"
#import "Vendor.h"
#import "City.h"
#import "Field.h"
#import "TransportDetail.h"

#import "ServerManager.h"

#define itemHeight 44
#define topMargin 60
#define buttonHeight 40
#define buttonWidth 340

@interface LoadingStatsViewController ()<MCPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate, DatePickerDelegate,HUDViewDelegate>
{
    NSDateFormatter *dateFormatter;
    NSArray* titleText;
    
    NSArray* vendorList;
    NSArray* cityList;
    NSArray* fieldList;
}

@property (nonatomic, strong) MCPickerView* pickerView;
@property (nonatomic, strong) AlertHUDView* alert;

@property (nonatomic, strong) LoadingStats* stats;
@property (nonatomic, strong) ServerManager* server;

@end

@implementation LoadingStatsViewController

-(void)viewDidLoad
{
    self.title = @"装载数据";
    
    [self.tableView registerClass:[LoadingCell class] forCellReuseIdentifier:@"loadingStats"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _stats = [[LoadingStats alloc] init];
    _server = [ServerManager sharedInstance];
    
    [self initTitlesAndImages];
}

#pragma mark titles and images
-(void)initTitlesAndImages
{
    titleText = @[@"供应商名称",@"地块编号",@"土豆重量", @"发车时间"];
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
        return 4;
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
        
        if (indexPath.row != 2 && indexPath.row != 3) {
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
        }
        else if(indexPath.row == 2)
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
        else
        {
            [cell setStyle:LoadingCellStyleDatePicker];
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            if(!_stats.departuretime)
            {
                cell.detailLabel.text = @"请选择时间";
            }
            else
            {
                cell.detailLabel.text = [dateFormatter stringFromDate:_stats.departuretime];
            }
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
        [confirm setFrame:CGRectMake((kScreen_Width-buttonWidth)/2, topMargin,buttonWidth , buttonHeight)];
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
                    [self requestVendors:city.name success:^{
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
                [self requestVendors:city.name success:^{
                    MCPickerView *pickerView = [[MCPickerView alloc] init];
                    pickerView.delegate =self;
                    pickerView.index = indexPath;
                    [pickerView setGreaterOrderData:cityList];
                    [pickerView setData:vendorList];
                    [pickerView show];
                }];

            }
        }
        else if(indexPath.row == 1)
        {
            if (!_stats.supplier) {
                _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
                _alert.delegate = self;
                _alert.title.text = @"错误";
                _alert.detail.text = @"请先选择供应商";
                [_alert show:_alert];
            }
            else
            {
                NSDictionary* params = @{@"token":_server.accessToken,
                                         @"vendorid":[NSString stringWithFormat:@"%lu", (unsigned long)_stats.supplier.vendorID]};
                [_server GET:@"getFieldList" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                    NSArray* data = responseObject[@"data"];
                    fieldList = [MTLJSONAdapter modelsOfClass:[Field class] fromJSONArray:data error:nil];
                    MCPickerView *pickerView = [[MCPickerView alloc] init];
                    pickerView.delegate = self;
                    [pickerView setData:fieldList];
                    pickerView.index = indexPath;
                    [pickerView show];
                    
                    Field* field = fieldList[0];
                    _stats.field = field;
                    [self.tableView reloadData];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
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

#pragma mark selectors
-(void)confirmBtn
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"token":_server.accessToken} copyItems:YES];
    if (_stats.supplier) {
        [params addEntriesFromDictionary:@{@"vendorid":[NSString stringWithFormat:@"%lu",_stats.supplier.vendorID]}];
    }
    if (_stats.field) {
        [params addEntriesFromDictionary:@{@"fieldid":[NSString stringWithFormat:@"%lu",_stats.field.fieldID]}];
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

#pragma mark MCPickerView delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath *indexPath = pickerView.index;
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            NSInteger components = [pickerView.picker numberOfComponents];
            if (component != components-1) { // not the last component
                City* selectedCity = [cityList objectAtIndex:row];
                [self requestVendors:selectedCity.name success:^{
                    [pickerView setData:vendorList];
                    [pickerView.picker reloadComponent:component+1];
                    Vendor* vendor = vendorList[0];
                    _stats.supplier = vendor;
                    
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
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_stats setWeight:[NSNumber numberWithFloat:[textField.text floatValue]]];
}

#pragma mark datePicker delegate
-(void)datePickerViewDidSelectDate:(NSDate *)date
{
    _stats.departuretime = date;
    [self.tableView reloadData];
}

#pragma mark web data requests
-(void)requestCityListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getCityList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSString* name in responseObject[@"data"]) {
            City* city = [[City alloc] initWithName:name];
            [array addObject:city];
        }
        cityList = array;
        success();
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
        success();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark alerts
-(void)didSelectConfirm
{
    [_alert removeFromSuperview];
}

@end
