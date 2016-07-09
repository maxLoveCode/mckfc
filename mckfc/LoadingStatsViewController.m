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

#import "LoadingStats.h"

#define itemHeight 44
#define topMargin 60
#define buttonHeight 40
#define buttonWidth 340

@interface LoadingStatsViewController ()<MCPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MCPickerView* pickerView;
@property (nonatomic, strong) LoadingStats* stats;

@end

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
    
    _stats = [[LoadingStats alloc] init];
    NSLog(@"%@", _stats);
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
        
        if (indexPath.row != 2) {
            [cell setStyle:LoadingCellStyleSelection];
            if (indexPath.row == 0) {
                cell.detailLabel.text = _stats.supplier;
            }
            else if (indexPath.row ==1){
                cell.detailLabel.text = _stats.placeNo;
            }
            else
            {
                
            }
        }
        else
        {
            [cell setStyle:LoadingCellStyleDigitInput];
            cell.digitInput.delegate = self;
            cell.digitInput.text = [NSString stringWithFormat:@"%@",_stats.weight];
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
        NSArray* offer = @[@"张三",@"李四",@"其他豆农"];
        NSArray* placeNo = @[@"A区", @"B区"];
        NSArray* timer = @[@"16:30", @"16:40", @"16:50"];
        NSArray* data;
        if (indexPath.section == 0 && indexPath.row ==0) {
            data = offer;
        }else if(indexPath.section == 0 && indexPath.row ==1){
            data = placeNo;
        }else{
            data = timer;
        }
        MCPickerView *pickerView = [[MCPickerView alloc] initWithArray:data];
        pickerView.delegate = self;
        pickerView.index = indexPath;
        [pickerView show];
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
    TranspotationPlanViewController *plan = [[TranspotationPlanViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:plan animated:YES];
}

#pragma mark MCPickerView delegate
-(void)didSelectString:(NSString *)string fromPickerView:(MCPickerView *)pickerView
{
    NSIndexPath *indexPath = pickerView.index;
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            _stats.supplier = string;
        }
        else if (indexPath.row ==1){
            _stats.placeNo = string;
        }
    }
    [self.tableView reloadData];
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

@end
