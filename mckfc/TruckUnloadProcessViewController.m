//
//  TruckUnloadProcessViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TruckUnloadProcessViewController.h"
#import "LoadingCell.h"


#define itemHeight 44
#define buttonHeight 40
#define topMargin 60
#define buttonWidth kScreen_Width-4*k_Margin

@implementation TruckUnloadProcessViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"进厂称重";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirm];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight*2+20) style:UITableViewStyleGrouped];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell* cell = [[LoadingCell alloc] init];
    if (indexPath.row == 0) {
        cell.style = LoadingCellStylePlain;
        cell.titleLabel.text = @"进场时间";
        cell.leftImageView.image = [UIImage imageNamed:@"土豆重量"];
        cell.detailLabel.text = self.workFlow.time;
    }
    else
    {
        cell.style = LoadingCellStyleDigitInput;
        cell.titleLabel.text = @"土豆重量";
        cell.leftImageView.image = [UIImage imageNamed:@"土豆重量"];
    }
    
    
    return cell;
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
