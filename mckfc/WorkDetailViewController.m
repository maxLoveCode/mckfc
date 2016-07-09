//
//  WorkDetailViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkDetailViewController.h"
#import "orderGeneralReport.h"
#import "WorkFlowCell.h"

#define itemHeight 44

@interface WorkDetailViewController()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* titleArray;
    NSArray* statusArray;
}

@property (nonatomic,strong) UITableView* tableView;

@end


@implementation WorkDetailViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    titleArray = @[@"供应商名称",@"地块编号",@"土豆重量",@"发车时间",@"预计到达时间"];
    statusArray = @[@"到厂",@"进厂",@"卸货",@"质检",@"出厂"];
}

#pragma mark setter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        NSString *const reuseIdentifier = @"workRecord";
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

#pragma mark UITableview controller
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || section == 2)
        return 5;
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *const reuseIdentifier = @"workRecord";
    //UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    UITableViewCell* cell =[[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        orderGeneralReport* report = [[orderGeneralReport alloc] init];
        report.titleLabel.text = titleArray[indexPath.row];
        report.detailLabel.text = @"meiyoushuju";
        report.leftImageView.image = [UIImage imageNamed:titleArray[indexPath.row]];
        return report;
    }
    else if(indexPath.section == 1){
        orderGeneralReport* report = [[orderGeneralReport alloc] init];
        report.detailLabel.textAlignment = NSTextAlignmentLeft;
        report.detailLabel.text = @"meiyoushuju";
        report.titleLabel.text = @"Max";
        [report.leftImageView setFrame:CGRectMake(k_Margin, (itemHeight-30)/2, 30, 30)];
        report.leftImageView.layer.cornerRadius = itemHeight/2;
        report.leftImageView.layer.masksToBounds = YES;
        report.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return report;
    }
    else
    {
        WorkFlowCell* workFlow = [[WorkFlowCell alloc] init];
        workFlow.titleLabel.text = statusArray[indexPath.row];
        return workFlow;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2){
        return 30;
    }
    else return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return [WorkFlowCell cellHeight];
    }
    return itemHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
        [bgView setBackgroundColor:COLOR_WithHex(0xfbeeae)];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = COLOR_WithHex(0xff9517);
        [bgView addSubview:label];
        
        if(section == 0)
        {
            label.text = @"订单编号：003040591";
        }
        else
        {
            label.text = @"接收报告：请工作人员按职责填写相应报告";
        }
        return bgView;
    }
    return nil;
}


@end
