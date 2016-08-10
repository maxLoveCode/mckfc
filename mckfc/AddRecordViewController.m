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

@interface AddRecordViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,DatePickerDelegate>
{
    NSArray* titleArray;
}

@property (nonatomic, strong) ServerManager* server;

@end

@implementation AddRecordViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
}

-(AddRecordTable *)tableView
{
    if (!_tableView) {
        _tableView = [[AddRecordTable alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        titleArray = @[@"车牌号", @"司机姓名", @"手机号码", @"土豆重量", @"运输单号",@"运输时间"];
        
        if (!_user) {
            _user = [[User alloc] init];
        }
        if (!_stats) {
            _stats = [[LoadingStats alloc] init];
        }
        _server = [ServerManager sharedInstance];
    }
    return _tableView;
}

-(MCDatePickerView *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[MCDatePickerView alloc] init];
        _datePicker.delegate = self;
        NSLog(@"init");
    }
    return _datePicker;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
    if (indexPath.row == 0) {
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
    }
    else if(indexPath.row == 1){
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
    else if(indexPath.row == 2){
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
    else if(indexPath.row == 3){
        cell.style = LoadingCellStyleDigitInput;
        cell.digitInput.tag = 3;
        cell.digitInput.textAlignment = NSTextAlignmentRight;
        cell.digitInput.delegate = self;
        cell.digitInput.text = [NSString stringWithFormat:@"%@", _stats.weight];
    }
     else if(indexPath.row == 4){
         cell.style = LoadingCellStyleTextInput;
         cell.textInput.delegate = self;
         cell.textInput.tag = 4;
         cell.textInput.textAlignment = NSTextAlignmentRight;
         cell.textInput.keyboardType = UIKeyboardTypePhonePad;
         cell.textInput.textColor = COLOR_WithHex(0x565656);
         cell.textInput.text = _stats.serialno;
         if (!_stats.serialno) {
             cell.textInput.textColor = COLOR_TEXT_GRAY;
             cell.textInput.text = @"请填写运输单号";
         }
     }
    else if(indexPath.row == 5){
        cell.style =LoadingCellStyleDatePicker;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        cell.detailLabel.text = [dateFormatter stringFromDate:_stats.departuretime];
    }
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:titleArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        [self.delegate requestDate:self];
        [self.datePicker show];
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
                [NSNumber numberWithInteger:[textField.text integerValue]];
            break;
        case 4:
            _stats.serialno = textField.text;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark datePicker delegate
-(void)datePickerViewDidSelectDate:(NSDate *)date
{
    _stats.departuretime = date;
    [self.tableView reloadData];
}

-(void)setDate:(NSDate*)date
{
    NSLog(@"set");
    [self.datePicker.picker setDate:date];
    [self.datePicker.picker setMinimumDate:date];
    [self.datePicker.picker setMaximumDate:[NSDate dateWithTimeInterval:24*60*60 sinceDate:date]];
}
@end
