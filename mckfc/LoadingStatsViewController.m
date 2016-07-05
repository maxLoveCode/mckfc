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

@interface LoadingStatsViewController ()<MCPickerViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) MCPickerView* pickerView;
@property (nonatomic, strong) LoadingStats* stats;

@end

@implementation LoadingStatsViewController
{
    NSDictionary* titleText;
    NSDictionary* secondSectionTitle;
    NSDictionary* thirdSectionTitle;
    NSDictionary* forthSectionTitle;
    
    NSMutableArray* checkMarks;
}

-(void)viewDidLoad
{
    self.title = @"装载数据";
    
    [self.tableView registerClass:[LoadingCell class] forCellReuseIdentifier:@"loadingStats"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _stats = [[LoadingStats alloc] init];
    [self initTitlesAndImages];
}

#pragma mark titles and images
-(void)initTitlesAndImages
{
    titleText = @{@"supplier":@"供应商名称",
                  @"placeNo":@"地块编号"};
    
    secondSectionTitle = @{@"":@"装车前车辆检查",
                           @"inspections":
                               @{
                                 @"异物":@"0",
                                 @"油":@"0",
                                 @"化学物品":@"0",
                                 @"异味":@"0",
                                 @"篷布":@"0"}};
    
    thirdSectionTitle =@{@"startTime":@"发车时间"};
    
    forthSectionTitle =@{@"extraInfo":@"其他情况说明"};
    
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
            }
            else{
                cell.style = LoadingCellStyleBoolean;
                cell.titleLabel.textColor = COLOR_TEXT_GRAY;
            }
        }
        else if (indexPath.section ==2){
            cell.style = LoadingCellStyleSelection;
        }
        else if (indexPath.section ==3){
            cell.style = LoadingCellStyleTextField;
            cell.textField.delegate = self;
            cell.textField.text = _stats.extraInfo;
        }

        //titles and left imageview
        NSArray* keys;
        NSString* imageName;
        if (indexPath.section == 0) {
            keys = [titleText allKeys];
            imageName = titleText[[keys objectAtIndex:indexPath.row]];
        }
        else if(indexPath.section == 1) {
            if (indexPath.row ==0) {
                keys = [secondSectionTitle allKeys];
                imageName = secondSectionTitle[[keys objectAtIndex:indexPath.row]];
            }
            else{
                keys = [[secondSectionTitle objectForKey:@"inspections"] allKeys];
                imageName = [keys objectAtIndex:indexPath.row-1];
            }
            
        }
        else if (indexPath.section ==2){
            keys = [thirdSectionTitle allKeys];
            imageName = thirdSectionTitle[[keys objectAtIndex:indexPath.row]];
        }
        else{
            keys = [forthSectionTitle allKeys];
            imageName = forthSectionTitle[[keys objectAtIndex:indexPath.row]];
        }
        
#pragma mark set properties
        cell.titleLabel.text = imageName;
        if ( indexPath.section ==1 && indexPath.row != 0) {
            cell.leftImageView.image = nil;
        }
        else{
            cell.leftImageView.image = [UIImage imageNamed:imageName];
        }
        
        //chechimages
        NSDictionary* dic = [MTLJSONAdapter JSONDictionaryFromModel:_stats error:nil];
        if(cell.style == LoadingCellStyleBoolean){
            //NSLog(@"dic%@",dic);
            if ([[checkMarks objectAtIndex:(indexPath.row-1)]integerValue] == 0) {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"uncheck"]];
            }
            else
            {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check"]];
            }
        }
        else if (cell.style == LoadingCellStyleSelection)
        {
            if(indexPath.section != 2)
                cell.detailLabel.text = dic[[keys objectAtIndex:indexPath.row]];
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
    if (cell.style == LoadingCellStyleBoolean) {
        if ([[checkMarks objectAtIndex:(indexPath.row-1)]integerValue] == 0) {
            [checkMarks setObject:@"1" atIndexedSubscript:(indexPath.row-1)];
        }
        else
        {
            [checkMarks setObject:@"0" atIndexedSubscript:(indexPath.row-1)];
        }
        
    }
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
    NSIndexPath *indexPath = pickerView.index;
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            _stats.supplier = string;
        }
        else{
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

@end
