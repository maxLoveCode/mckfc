//
//  LoadingStatsViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoadingStatsViewController.h"
#import "TranspotationPlanViewController.h"
#import "LoadingCell.h"
#import "MCPickerView.h"

#define itemHeight 44
#define topMargin 60
#define buttonHeight 40
#define buttonWidth 340

@interface LoadingStatsViewController ()<MCPickerViewDelegate>

@property (nonatomic, strong) MCPickerView* pickerView;

@end

@implementation LoadingStatsViewController
{
    NSArray* titleText;
    NSArray* secondSectionTitle;
    NSArray* thirdSectionTitle;
    NSArray* forthSectionTitle;
    
    NSMutableArray* checkMarks;
}

-(void)viewDidLoad
{
    self.title = @"装载数据";
    
    [self.tableView registerClass:[LoadingCell class] forCellReuseIdentifier:@"loadingStats"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self initTitlesAndImages];
}

#pragma mark titles and images
-(void)initTitlesAndImages
{
    titleText = @[@"供应商名称",@"地块编号"];
    secondSectionTitle = @[@"装车前车辆检查",@"异物",@"油",@"化学物品",@"异味",@"篷布"];
    thirdSectionTitle =@[@"发车时间"];
    forthSectionTitle =@[@"其他情况说明"];
    
    checkMarks = [[NSMutableArray alloc] initWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        return kScreen_Height-itemHeight*12-40;
    }
    else if(indexPath.section == 3)
    {
        return itemHeight*2;
    }
    else
        return itemHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return 6;
    }
    else
        return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section !=4) {
        LoadingCell* cell = [[LoadingCell alloc] init];
        if (indexPath.section == 0) {
            cell.style = LoadingCellStyleSelection;
        }
        else if (indexPath.section ==1){
            if (indexPath.row ==0) {
                [cell setStyle:LoadingCellStylePlain];
                cell.leftImageView.image = [UIImage imageNamed:secondSectionTitle[indexPath.row]];
            }
            else{
                cell.style = LoadingCellStyleBoolean;
                cell.leftImageView.image = nil;
                cell.titleLabel.textColor = COLOR_TEXT_GRAY;
            }
        }
        else if (indexPath.section ==2){
            cell.style = LoadingCellStyleSelection;
        }
        else if (indexPath.section ==3){
            cell.style = LoadingCellStyleTextField;
        }

        //titles and left imageview
        if (indexPath.section == 0) {
            cell.titleLabel.text = titleText[indexPath.row];
            cell.leftImageView.image = [UIImage imageNamed:titleText[indexPath.row]];
        }
        else if(indexPath.section == 1) {
            cell.titleLabel.text = secondSectionTitle[indexPath.row];
        }
        else if (indexPath.section ==2){
            cell.titleLabel.text = thirdSectionTitle[indexPath.row];
            cell.leftImageView.image = [UIImage imageNamed:thirdSectionTitle[indexPath.row]];
        }
        else{
            cell.titleLabel.text = forthSectionTitle[indexPath.row];
            cell.leftImageView.image = [UIImage imageNamed:forthSectionTitle[indexPath.row]];
        }
        
        //chechimages
        if(cell.style == LoadingCellStyleBoolean){
            if ([[checkMarks objectAtIndex:(indexPath.row-1)]integerValue] == 0) {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"uncheck"]];
            }
            else
            {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check"]];
            }
        }
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
//    if (indexPath.section == 0) {
//        if (cell.style == LoadingCellStyleSelection) {
//            NSArray *strings = @[@"A", @"B", @"C", @"an D", @"E"];
//            _pickerView = [[MCPickerView alloc] initWithArray:strings];
//            _pickerView.delegate = self;
//            _pickerView.tag = indexPath.row;
//            [_pickerView show];
//        }
//    }
    if (cell.style == LoadingCellStyleBoolean) {
        if ([[checkMarks objectAtIndex:(indexPath.row-1)]integerValue] == 0) {
            [checkMarks setObject:@"1" atIndexedSubscript:(indexPath.row-1)];
        }
        else
        {
            [checkMarks setObject:@"0" atIndexedSubscript:(indexPath.row-1)];
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
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 30;
    }
    else
        return tableView.sectionHeaderHeight;
}

#pragma mark selectors
-(void)confirmBtn
{
    TranspotationPlanViewController *plan = [[TranspotationPlanViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:plan animated:YES];
}

#pragma mark MCPickerView delegate
-(void)didSelectString:(NSString *)string fromPickerView:(MCPickerView *)pickerView
{
    LoadingCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:pickerView.tag inSection:0]];
    cell.detailLabel.text = string;
}

@end
