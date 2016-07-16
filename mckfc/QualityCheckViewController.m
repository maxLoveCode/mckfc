//
//  QualityCheckViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QualityCheckViewController.h"
#import "LoadingCell.h"

@interface QualityCheckViewController ()
{
    NSArray* criteria;
}

@end

@implementation QualityCheckViewController

#define itemHeight 44
#define buttonHeight 40
#define topMargin 60
#define buttonWidth kScreen_Width-4*k_Margin

-(void)viewDidLoad
{
    self.title = @"库房报告";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirm];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    criteria = @[@"无异物",@"无油",@"无化学物品",@"无异味"];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight*6+20*2) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"weight"];
        _tableView.bounces = NO;
    }
    return _tableView;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"确认" forState:UIControlStateNormal];
        [_confirm setBackgroundColor:COLOR_THEME];
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _confirm.layer.cornerRadius = 3;
        _confirm.layer.masksToBounds = YES;
        [_confirm setFrame:CGRectMake(2*k_Margin,topMargin+CGRectGetMaxY(self.tableView.frame),buttonWidth , buttonHeight)];
    }
    return _confirm;
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell* cell = [[LoadingCell alloc] init];
    if (indexPath.section == 0) {
        
    }
    else
    {
        if (indexPath.row != 0) {
            cell.style = LoadingCellStyleBoolean;
            cell.titleLabel.text = criteria[indexPath.row-1];
            
            UIImageView* view = (UIImageView*)cell.accessoryView;
            if (cell.tag == 0) {
                view.image = [UIImage imageNamed:@"check"];
                
            }
            else
            {
                view.image = [UIImage imageNamed:@"uncheck"];
            }
            cell.accessoryView = view;
        }
        else
        {
            cell.style = LoadingCellStylePlain;
            cell.titleLabel.text = @"车辆检查";
            cell.leftImageView.image = [UIImage imageNamed:@"装车前车辆检查"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.style == LoadingCellStyleBoolean) {
        cell.tag = !cell.tag;
        NSLog(@"%lu",(long)cell.tag);
    }
    [tableView reloadData];
}

#pragma mark header and footers
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

@end
