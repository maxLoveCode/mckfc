//
//  LoadingStatsViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoadingStatsViewController.h"
#import "MapViewController.h"

#define itemHeight 44
#define topMargin 60
#define buttonHeight 40
#define buttonWidth 340

@implementation LoadingStatsViewController

-(void)viewDidLoad
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"loadingStats"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return itemHeight;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingStats" forIndexPath:indexPath];
    
    if (indexPath.section ==1) {
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
    }
    return cell;
}

-(void)confirmBtn
{
    MapViewController* map = [[MapViewController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
}

@end
