                    //
//  ReportViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/30.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportCollectionView.h"

#import "ServerManager.h"

#import "Report.h"

#define  itemHeight 44

#define topMargin 60

#define buttonHeight 40
#define buttonWidth 340

extern NSString *const reuseIdentifier;

@interface ReportViewController()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _reject;
    NSArray* titleArray;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ReportCollectionView* reportView;
@property (nonatomic, strong) ServerManager* server;

@property (nonatomic, strong) Report* report;

@end

@implementation ReportViewController

-(void)viewDidLoad
{
    self.title = @"验收报告";
    titleArray = @[@"发车时间:",@"到达时间:",@"行驶里程:",@"运输耗时:"];
    
    _reject = NO;
    self.view = self.tableView;
    
    _server = [ServerManager sharedInstance];
    [self requestReport];
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

-(ReportCollectionView *)reportView
{
    if (!_reportView) {
        _reportView = [[ReportCollectionView alloc] init];
    }
    return _reportView;
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
        if(_reject)
            return kScreen_Height-itemHeight*10-20*3;
        else
            return kScreen_Height-itemHeight*10-20*3 + itemHeight;
    }
    return itemHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const reuseIdentifier = @"reportTable";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    for (UIView* subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        [cell.contentView addSubview: self.reportView];
        return cell;
    }
    else if(indexPath.section ==0 && indexPath.row == 1){
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin*2+10, 0, 80, itemHeight)];
        titleLabel.text = titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = COLOR_TEXT_GRAY;
        
        UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, kScreen_Width-CGRectGetMaxX(titleLabel.frame), itemHeight)];
        [cell.contentView addSubview:detailLabel];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = COLOR_WithHex(0x565656);
        
        titleLabel.text = @"拒收全部:";
        detailLabel.text = _report.refusecause;
    }
    else if(indexPath.section ==1)
    {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(k_Margin*2, 0, 100, itemHeight)];
        titleLabel.text = titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = COLOR_TEXT_GRAY;
        
        UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, kScreen_Width-CGRectGetMaxX(titleLabel.frame), itemHeight)];
        [cell.contentView addSubview:detailLabel];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = COLOR_WithHex(0x565656);
        
        if (indexPath.row == 0) {
            detailLabel.text = _report.departuretime;
        }
        else if(indexPath.row == 1){
            detailLabel.text = _report.arrivetime;
        }
        else if(indexPath.row ==2){
            detailLabel.text = [NSString stringWithFormat:@"%@",_report.totaldistance];
        }
        else if(indexPath.row ==3){
            detailLabel.text = _report.totalTime;
        }
        
        return cell;
    }
    else if(indexPath.section ==2)
    {
        [cell.contentView addSubview:self.confirm];
        return cell;
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
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = COLOR_WithHex(0x565656);
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

#pragma mark weblayer
-(void)requestReport
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"id":@"48"};
    [_server GET:@"getTransportReport" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        NSError* error;
        _report = [MTLJSONAdapter modelOfClass:[Report class] fromJSONDictionary:data error:&error];
        
        if (error) {
            NSLog(@"%@",error);
        }
        
        _reject = _report.isrefuse;
        [self.tableView reloadData];
        
        self.reportView.report = _report;
        [self.reportView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
