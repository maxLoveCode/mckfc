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

extern NSString *const reuseIdentifier;

@interface ReportViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ReportCollectionView* report;

@end

@implementation ReportViewController

-(void)viewDidLoad
{
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return itemHeight*3;
        }
    }
    return itemHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const reuseIdentifier = @"reportTable";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 1) {
        //[cell.contentView addSubview: self.report];
    }
    
    return cell;
}


@end
