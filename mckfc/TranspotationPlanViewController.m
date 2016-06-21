//
//  TranspotationPlanViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/21.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TranspotationPlanViewController.h"
#import "TransportationViewCell.h"
#import "MapViewController.h"

#define itemHeight 44

@interface TranspotationPlanViewController()

@property (nonatomic, strong) MapViewController* mapVC;

@end


@implementation TranspotationPlanViewController
{
    NSArray* titleText;
}

-(void)viewDidLoad
{
    self.title = @"运输计划";
    
    [self.tableView registerClass:[TransportationViewCell class] forCellReuseIdentifier:@"plan"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _mapVC = [[MapViewController alloc] init];
    [self addChildViewController:_mapVC];
    
    titleText = @[@"发运时间",@"运输目的地",@"计划到达时间",@"计划卸货时间"];
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 4) {
        
        return itemHeight;
    }
    else
        return kScreen_Height-itemHeight*6-20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 4)
    {
        TransportationViewCell* cell = [[TransportationViewCell alloc] init];
        cell.titleLabel.text = titleText[indexPath.row];
        return cell;
    }
    else if(indexPath.row ==4)
    {
        UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"plan" forIndexPath:indexPath];
        [_mapVC.view setFrame:cell.contentView.frame];
        [cell.contentView addSubview:_mapVC.view];
        return cell;
    }
    else
    {
        UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"plan" forIndexPath:indexPath];
        
        UIButton* confirm;
        confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:@"我已到厂前" forState:UIControlStateNormal];
        [confirm setBackgroundColor:COLOR_THEME];
        [confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        [confirm setFrame: cell.contentView.frame];
        [confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:confirm];
        
        return cell;
    }
}

#pragma selector
-(void)confirmBtn
{
    
}
@end
