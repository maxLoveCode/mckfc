//
//  QueueViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/21.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QueueViewController.h"
#import "QRCodeView.h"

#import "ReportViewController.h"

#define itemHeight 44
#define topMargin 60

@interface QueueViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* titleText;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) QRCodeView* QRCode;

@end

@implementation QueueViewController

-(void)viewDidLoad
{
    titleText = @[@"前面等待车辆：",@"预计等待时间："];
    self.view = self.tableView;
}

#pragma mark setter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Queue"];
    }
    return _tableView;
}

-(QRCodeView *)QRCode
{
    if (!_QRCode) {
        _QRCode = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, 288, 288)];
        [_QRCode setCenter:CGPointMake(kScreen_Width/2, itemHeight+topMargin+144)];
    }
    return _QRCode;
}

#pragma mark tableViewDelegate
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
        if (indexPath.row == 0) {
            return itemHeight*2;
        }
        else{
            return itemHeight;
        }
    }
    else
    {
        return kScreen_Height-64-itemHeight*4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Queue" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UILabel* label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, cell.contentView.frame.size.height)];
            label.text = @"序号：001";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:20];
            label.textColor = COLOR_WithHex(0x2f2f2f);
            [cell.contentView addSubview:label];
            return cell;
        }
        else{
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, 100, itemHeight)];
            titleLabel.text = titleText[indexPath.row-1];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = COLOR_TEXT_GRAY;
            [cell.contentView addSubview:titleLabel];
            return cell;
        }
    }
    else
    {
        UILabel* label =[[UILabel alloc] initWithFrame:CGRectMake(k_Margin, 0, kScreen_Width-k_Margin*2, itemHeight*2)];
        label.text = @"卸货时请出示下列二维码，收货人员可快速验收货物信息，提高您的卸货速度";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = COLOR_TEXT_GRAY;
        label.numberOfLines = 2;
        [cell.contentView addSubview:label];
        
        [self.QRCode setQRCode:@"test"];
        [cell.contentView addSubview:self.QRCode];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self generateReport];
}

-(void)generateReport
{
    ReportViewController* reportVC = [[ReportViewController alloc] init];
    [self.navigationController pushViewController:reportVC animated:YES];
}

@end
