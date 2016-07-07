                    //
//  ReportViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/30.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportCollectionView.h"

#define  itemHeight 44

#define topMargin 60

#define buttonHeight 40
#define buttonWidth 340

extern NSString *const reuseIdentifier;

@interface ReportViewController()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _reject;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ReportCollectionView* report;

@end

@implementation ReportViewController

-(void)viewDidLoad
{
    
    _reject = NO;
    self.view = self.tableView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSString *const reuseIdentifier = @"reportTable";
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

-(ReportCollectionView *)report
{
    if (!_report) {
        _report = [[ReportCollectionView alloc] init];
    }
    return _report;
}

#pragma mark UITableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_reject) {
            return 2;
        }
        return 1;
    }
    else if (section ==1) {
        return 4;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return itemHeight*2;
        }
    }
    else if(indexPath.section ==2){
        return kScreen_Height-itemHeight*10-20*3;
    }
    return itemHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const reuseIdentifier = @"reportTable";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        [cell.contentView addSubview: self.report];
    }
    else if(indexPath.section ==2)
    {
        [cell.contentView addSubview:self.confirm];
    }
    
    return cell;
}

#pragma mark tableview height footer
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section ==1)
    {
        return itemHeight;
    }
    else
        return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section ==1) {
        UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, itemHeight)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        if (section ==0) {
            label.text = @"收货完成，以下是您的验收报告";
            label.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            label.text = @"运输信息";
        }
        [bgView addSubview:label];
        return bgView;
    }
    else
        return nil;
}

#pragma  mark button
-(UIButton *)confirm
{
    UIButton* confirm;
    confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setTitle:@"进行下一次运输" forState:UIControlStateNormal];
    [confirm setBackgroundColor:COLOR_THEME];
    [confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
    confirm.layer.cornerRadius = 3;
    confirm.layer.masksToBounds = YES;
    [confirm setFrame:CGRectMake((kScreen_Width-buttonWidth)/2, topMargin,buttonWidth , buttonHeight)];
    [confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
    return confirm;
}

-(void)confirmBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
