//
//  WorkDetailViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkDetailViewController.h"

@interface WorkDetailViewController()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* titleArray;
}

@property (nonatomic,strong) UITableView* tableView;

@end


@implementation WorkDetailViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    titleArray = @[@"供应商名称",@"地块编号",@"土豆重量",@"发车时间",@"预计到达时间"];
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
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 5;
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const reuseIdentifier = @"workRecord";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (indexPath.section == 0) {
        cell.textLabel.text = titleArray[indexPath.row];
        cell.detailTextLabel.text = @"detail";
        cell.imageView.image = [UIImage imageNamed:titleArray[indexPath.row]];
        
    }
    return cell;
}


@end
