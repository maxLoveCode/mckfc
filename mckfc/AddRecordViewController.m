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

@interface AddRecordViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,DatePickerDelegate,MCPickerViewDelegate>
{
    NSArray* titleArray;
    NSArray *_imgArray;
    NSArray* packageList;
    NSArray *_storageList;
    NSArray *_varietylist;
}

@property (nonatomic, strong) ServerManager* server;

@end

@implementation AddRecordViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    self.timeFlag = @"0";
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
            
            NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"HH:mm"];
            NSDate* date = [formatter2 dateFromString:@"00:00"];
            _stats.departuretime = date;
            _stats.planarrivetime = date;
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
                cell.textInput.text = [_stats.serialno substringToIndex:2];
            }else{
                cell.textInput.text = _stats.serialno;
            }
            
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
        [self.delegate requestDate:self];
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
            _stats.serialno = [NSString stringWithFormat:@"%@",textField.text];
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
        [self.datePicker.picker setDate:date];
        [self.datePicker.picker setMinimumDate:nil];
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
@end
