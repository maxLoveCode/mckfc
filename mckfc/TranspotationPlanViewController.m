//
//  TranspotationPlanViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/21.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TranspotationPlanViewController.h"
#import "TransportationViewCell.h"

#define itemHeight 44

@implementation TranspotationPlanViewController
{
    NSArray* titleText;
}

-(void)viewDidLoad
{
    self.title = @"运输计划";
    
    titleText = @[@"发运时间",@"运输目的地",@"计划到达时间",@"计划卸货时间"];
    [self.tableView registerClass:[TransportationViewCell class] forCellReuseIdentifier:@"plan"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"plan" forIndexPath:indexPath];
        return cell;
    }
}


@end
