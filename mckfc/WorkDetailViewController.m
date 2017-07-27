//
//  WorkDetailViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkDetailViewController.h"
#import "InspectDetailView.h"
#import "TruckArrivePicker.h"
#import "NewInspectionController.h"
#define itemHeight 44

@interface WorkDetailViewController()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* titleArray;
    NSArray* statusArray;
}

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) ServerManager* server;
@property (nonatomic,strong) WorkDetail* detail;


@end


@implementation WorkDetailViewController

-(void)viewDidLoad
{
    self.view = self.tableView;
    self.title = @"记录详情";  
    titleArray = @[@"供应商名称",@"地块编号",@"土豆重量",@"发车时间",@"计划到达时间",@"运单号",@"包装类型",@"土豆种类",@"储存期"];
    
    _server = [ServerManager sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self requestDetail];
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
    if(section == 0)
        return [titleArray count];
    else if(section ==2)
        return [statusArray count];
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell =[[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        orderGeneralReport* report = [[orderGeneralReport alloc] init];
        report.titleLabel.text = titleArray[indexPath.row];
        report.detailLabel.text = @"未填写";
        report.leftImageView.image = [UIImage imageNamed:titleArray[indexPath.row]];
        if (indexPath.row == 0) {
            report.detailLabel.text = _detail.vendorname;
        }
        else if(indexPath.row ==1){
            report.detailLabel.text = _detail.fieldno;
        }
        else if(indexPath.row ==2){
            report.detailLabel.text = [NSString stringWithFormat:@"%@吨", _detail.weight];
        }
        else if(indexPath.row ==3){
            report.detailLabel.text = _detail.departuretime;
        }
        else if(indexPath.row ==4){
            report.detailLabel.text = _detail.planarrivetime;
        }
        else if(indexPath.row ==5){
            report.detailLabel.text = _detail.serialno;
        }
        else if(indexPath.row ==6){
            report.detailLabel.text = _detail.packagename;
        }
        else if(indexPath.row ==7){
            report.detailLabel.text = _detail.varietyname;
        }
        else if(indexPath.row ==8){
            report.detailLabel.text = _detail.storagetime;
        }
        return report;
    }
    else if(indexPath.section == 1){
        orderGeneralReport* report = [[orderGeneralReport alloc] init];
        report.detailLabel.textAlignment = NSTextAlignmentLeft;
        report.detailLabel.text = _detail.truckno;
        report.titleLabel.text = _detail.driver;
        [report.leftImageView setFrame:CGRectMake(k_Margin, (itemHeight-30)/2, 30, 30)];
        report.leftImageView.layer.cornerRadius = itemHeight/2;
        report.leftImageView.layer.masksToBounds = YES;
        
        [report.leftImageView sd_setImageWithURL:[NSURL URLWithString:_detail.avatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        report.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView* phone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
        [phone setFrame:CGRectMake(CGRectGetWidth(report.contentView.frame)+10, 0, itemHeight, itemHeight)];
        [report.contentView addSubview:phone];
        return report;
    }
    else
    {
        WorkFlowCell* workFlow = [[WorkFlowCell alloc] init];
        [workFlow setWorkFlow:statusArray[indexPath.row]];
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
            label.text = [NSString stringWithFormat:@"订单编号：%@",_detail.serialno];
        }
        else
        {
            label.text = @"接收报告：请工作人员按职责填写相应报告";
        }
        return bgView;
    }
    return nil;
}

#pragma mark selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        WorkFlow* workFlow = statusArray[indexPath.row];
        if ([workFlow.type isEqualToString:@"enter"]) {
            TruckUnloadProcessViewController* unloadVC = [[TruckUnloadProcessViewController alloc] init];
            [unloadVC setWorkFlow:workFlow];
            [unloadVC setTransportid:self.transportid];
            if (workFlow.auth) {
                [self.navigationController pushViewController:unloadVC animated:YES];
            }
        }
        else if([workFlow.type isEqualToString:@"unload"]){
            QualityCheckViewController* qcVC = [[QualityCheckViewController alloc] init];
            [qcVC setWorkFlow:workFlow];
            [qcVC setTransportid:self.transportid];
            if (workFlow.auth) {
                [self.navigationController pushViewController:qcVC animated:YES];
            }
        }
        else if([workFlow.type isEqualToString:@"arrive"]){
            if (workFlow.auth) {
                [self inspectArrivedTruck];
            }
        }
        else if([workFlow.type isEqualToString:@"checkone"]){
            NewInspectionController* inspectVC = [[NewInspectionController alloc] init];
            inspectVC.transportid = self.transportid;
            inspectVC.workFlow = workFlow;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"]) {
               NSString* user_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"];
                if ([user_type isEqualToString:@"4"]) {
                    inspectVC.mainType = @"1";
                }else{
                    inspectVC.mainType = @"2";
                }
            }
            inspectVC.type = @"1";
            if (workFlow.ischecked || workFlow.auth) {
                [self.navigationController pushViewController:inspectVC animated:YES];
            }
            
        }
        else if([workFlow.type isEqualToString:@"checktwo"]){
            NewInspectionController* inspectVC = [[NewInspectionController alloc] init];
            inspectVC.transportid = self.transportid;
            inspectVC.type = @"2";
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"]) {
                NSString* user_type = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"];
                if ([user_type isEqualToString:@"4"]) {
                    inspectVC.mainType = @"1";
                }else{
                    inspectVC.mainType = @"2";
                }
            }
            inspectVC.workFlow = workFlow;
            if (workFlow.ischecked || workFlow.auth) {
                [self.navigationController pushViewController:inspectVC animated:YES];
            }
        }
        else if([workFlow.type isEqualToString:@"leave"]){
            TruckUnloadProcessViewController* unloadVC = [[TruckUnloadProcessViewController alloc] init];
            [unloadVC setWorkFlow:workFlow];
            [unloadVC setTransportid:self.transportid];
            if (workFlow.auth) {
                [self.navigationController pushViewController:unloadVC animated:YES];
            }
        }
    }
    else if(indexPath.section ==1)
    {
        NSString* phone = self.detail.mobile;
        if (![phone isEqualToString:@""]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
        }
    }
    
}

#pragma mark request web data
-(void)requestDetail
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"transportid":_transportid};
    
    [_server GET:@"getOrderDetail" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        
        NSLog(@"response%@", data);
        NSError* error;
        _detail = [MTLJSONAdapter modelOfClass:[WorkDetail class] fromJSONDictionary:data error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        statusArray = [MTLJSONAdapter modelsOfClass:[WorkFlow class] fromJSONArray:_detail.report error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark- 车辆到厂
- (void)inspectArrivedTruck
{
    TruckArrivePicker* picker = [[TruckArrivePicker alloc] init];
    [picker show];
    [picker setSelectBlock:^(NSDate *result) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formater stringFromDate:result];
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"token": _server.accessToken,
                            @"transportid":_transportid}];
        if (dateString != nil && ![dateString isEqualToString:@""]) {
            [params addEntriesFromDictionary:@{@"arrivetime":dateString}];
        }
        
        NSLog(@"%@", params);
        [_server POST:@"truckArrive" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [self requestDetail];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }];
    
}

@end
