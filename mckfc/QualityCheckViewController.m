//
//  QualityCheckViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QualityCheckViewController.h"
#import "LoadingCell.h"

#import "MCPickerView.h"
#import "ServerManager.h"

#import "Store.h"
#import "StoreReport.h"

@interface QualityCheckViewController ()<MCPickerViewDelegate>
{
    NSArray* criteria;
}
@property (nonatomic, strong) NSArray* storeList;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) StoreReport* report;
@end

@implementation QualityCheckViewController

#define itemHeight 44
#define buttonHeight 40
#define topMargin 60
#define buttonWidth kScreen_Width-4*k_Margin

-(void)viewDidLoad
{
    self.title = @"库房报告";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirm];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _server = [ServerManager sharedInstance];
    criteria = @[@"无异物",@"无油",@"无化学物品",@"无异味"];
    
    _report = [[StoreReport alloc] initWithTransportID:self.transportid];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, itemHeight*6+20*2) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"weight"];
        _tableView.bounces = NO;
    }
    return _tableView;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"确认" forState:UIControlStateNormal];
        [_confirm setBackgroundColor:COLOR_THEME];
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _confirm.layer.cornerRadius = 3;
        _confirm.layer.masksToBounds = YES;
        [_confirm setFrame:CGRectMake(2*k_Margin,topMargin+CGRectGetMaxY(self.tableView.frame),buttonWidth , buttonHeight)];
    }
    return _confirm;
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell* cell = [[LoadingCell alloc] init];
    if (indexPath.section == 0) {
        cell.style = LoadingCellStyleSelection;
        cell.titleLabel.text = @"接受仓库位置";
        if (!self.report.store.storeID||self.report.store.storeID == 0) {
            cell.detailLabel.text = @"请选择仓库";
        }
        else
            cell.detailLabel.text = _report.store.name;
    }
    else
    {
        if (indexPath.row != 0) {
            cell.style = LoadingCellStyleBoolean;
            cell.titleLabel.text = criteria[indexPath.row-1];
            
            UIImageView* view = (UIImageView*)cell.accessoryView;
            if (indexPath.row == 1) {
                if (_report.material) {
                    cell.tag = 1;
                }
            }
            else if(indexPath.row == 2){
                if (_report.petrol) {
                    cell.tag = 1;
                }
            }
            else if(indexPath.row == 3){
                if (_report.chemical) {
                    cell.tag = 1;
                }
            }
            else if(indexPath.row == 4){
                if (_report.smell) {
                    cell.tag = 1;
                }
            }
            
            if (cell.tag == 1) {
                view.image = [UIImage imageNamed:@"check"];
                
            }
            else
            {
                view.image = [UIImage imageNamed:@"uncheck"];
            }
            cell.accessoryView = view;
        }
        else
        {
            cell.style = LoadingCellStylePlain;
            cell.titleLabel.text = @"车辆检查";
            cell.leftImageView.image = [UIImage imageNamed:@"装车前车辆检查"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.style == LoadingCellStyleBoolean) {
        if (indexPath.row == 1) {
            _report.material = !_report.material;
        }
        else if(indexPath.row == 2){
            _report.petrol = !_report.petrol;
        }
        else if(indexPath.row == 3){
            _report.chemical = !_report.chemical;
        }
        else if(indexPath.row == 4){
            _report.smell = !_report.smell;
        }

    }
    if (cell.style == LoadingCellStyleSelection){
        if (!_storeList) {
            [self requestStoreListSuccess:^{
               MCPickerView *pickerView = [[MCPickerView alloc] init];
                pickerView.delegate =self;
                [pickerView setData:_storeList];
                [pickerView show];
            }];
        }
        else
        {
            MCPickerView *pickerView = [[MCPickerView alloc] init];
            pickerView.delegate =self;
            [pickerView setData:_storeList];
            [pickerView show];
        }
    }
    [tableView reloadData];
}

#pragma mark header and footers
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma mark web data requests
-(void)requestStoreListSuccess:(void (^)(void))success
{
    NSDictionary* params = @{@"token": _server.accessToken};
    [_server GET:@"getStoreList" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray* jsonArray = responseObject[@"data"];
        NSError* error;
        _storeList = [MTLJSONAdapter modelsOfClass:[Store class] fromJSONArray:jsonArray error:&error];
        if (_storeList) {
            success();
            _report.store = _storeList[0];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark pickerview delegate
-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _report.store = _storeList[row];
    [self.tableView reloadData];
}
@end
