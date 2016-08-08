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
#import "User.h"

@interface AddRecordViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSArray* titleArray;
}

@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) User* user;

@end

@implementation AddRecordViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    _user = [[User alloc] init];
}

-(AddRecordTable *)tableView
{
    if (!_tableView) {
        _tableView = [[AddRecordTable alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        titleArray = @[@"车牌号", @"司机姓名", @"手机号码", @"土豆重量", @"运输时间"];
        
        _server = [ServerManager sharedInstance];
    }
    return _tableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
        cell.textInput.delegate = self;
        cell.textInput.text = _user.cardigits;
    }
    else if(indexPath.row == 1){
        cell.style = LoadingCellStyleTextInput;
        cell.textInput.delegate = self;
        cell.textInput.text = _user.driver;
    }
    else if(indexPath.row == 2){
        cell.style = LoadingCellStyleTextInput;
        cell.textInput.delegate = self;
        cell.textInput.text = _user.mobile;
    }
    else if(indexPath.row == 3){
        cell.style = LoadingCellStyleDigitInput;
        cell.digitInput.delegate = self;
    }
    else if(indexPath.row == 4){
        cell.style =LoadingCellStyleDatePicker;
    }
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:titleArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
             //__weak User* weakref = self.driver;
             [selector setSelectBlock:^(NSString *result) {
                 //weakref.region = result;
                 UIButton* button = sender;
                 button.selected = YES;
                 [_tableView reloadData];
             }];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
    }];
}

#pragma mark- textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tableView scrollsToTop];
    [self.delegate addRecordView:self.tableView];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"end");
    [self.delegate endEditing:self.tableView];
}


@end
