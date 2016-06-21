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

#define itemHeight 44
#define topMargin 60
#define buttonHeight 40
#define buttonWidth 340

@implementation LoadingStatsViewController
{
    NSArray* titleText;
}

-(void)viewDidLoad
{
    self.title = @"装载数据";
    
    [self.tableView registerClass:[LoadingCell class] forCellReuseIdentifier:@"loadingStats"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    titleText = @[@"豆农",@"土豆重量",@"土豆品质",@"篷布",@"排风系统",@"发车时间"];
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row != 5) {
            return itemHeight;
        }
        else
            return itemHeight*2;
    }
    else
    {
        return kScreen_Height-itemHeight*6-80;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    else
        return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            LoadingCell* cell = [[LoadingCell alloc] initWithStyle:LoadingCellStyleSelection];
            cell.titleLabel.text = titleText[indexPath.row];
            return cell;
        }else if(indexPath.row ==1){
            LoadingCell* cell = [[LoadingCell alloc] initWithStyle:LoadingCellStyleTextField];
            cell.titleLabel.text = titleText[indexPath.row];
            return cell;
        }else if (indexPath.row ==2){
            LoadingCell* cell = [[LoadingCell alloc] initWithStyle:LoadingCellStyleSelection];
            cell.titleLabel.text = titleText[indexPath.row];
            return cell;
        }else if (indexPath.row ==3){
            LoadingCell* cell = [[LoadingCell alloc] initWithStyle:LoadingCellStyleTextField];
            cell.titleLabel.text = titleText[indexPath.row];
            return cell;
        }else if (indexPath.row ==4){
            LoadingCell* cell = [[LoadingCell alloc] initWithStyle:LoadingCellStyleImagePicker];
            cell.titleLabel.text = titleText[indexPath.row];
            return cell;
        }else{
            LoadingCell* cell = [[LoadingCell alloc] initWithStyle:LoadingCellStyleSelection];
            cell.titleLabel.text = titleText[indexPath.row];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin, itemHeight, kScreen_Width-2* k_Margin, itemHeight)];
            label.text = @"发车时间直接影响运输计划的时间和安排，时间填写错误可能导致无法正常卸货，请仔细填写!";
            label.textColor = [UIColor redColor];
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            
            [cell.contentView addSubview:label];
            return cell;
        }
        
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingStats" forIndexPath:indexPath];
        
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

-(void)confirmBtn
{
    TranspotationPlanViewController *plan = [[TranspotationPlanViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:plan animated:YES];
}

@end
