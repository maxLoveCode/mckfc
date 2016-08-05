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

@interface AddRecordViewController ()<UITableViewDelegate, UITableViewDataSource>\
{
    NSArray* titleArray;
}

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
        titleArray = @[@"车牌号", @"司机姓名", @"手机号码", @"土豆重量", @"运输时间"];
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
    }
    else if(indexPath.row == 1){
        cell.style = LoadingCellStyleTextInput;
    }
    else if(indexPath.row == 2){
        cell.style = LoadingCellStyleTextInput;
    }
    else if(indexPath.row == 3){
        cell.style = LoadingCellStyleDigitInput;
    }
    else if(indexPath.row == 4){
        cell.style =LoadingCellStyleDatePicker;
    }
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:titleArray[indexPath.row]];
    return cell;
}


@end
