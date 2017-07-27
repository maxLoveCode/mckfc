//
//  InspectDetailView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "InspectDetailView.h"

@implementation InspectDetailView

-(instancetype)init
{
    self = [super init];
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];
    [self addSubview:self.detailView];
    [self addSubview:self.confirm];
    [self addSubview:self.cancel];
    self.detailView.backgroundColor = [UIColor whiteColor];
    [self layout];
    
    titleArray = @[@"供应商名称",@"地块编号",@"土豆重量",@"发车时间",@"车牌号",@"运单号",@"包装类型",@"土豆种类",@"储存期"];
    _detail = [[WorkDetail alloc] init];
    
    return self;
}

-(UITableView *)detailView
{
    if (!_detailView) {
        _detailView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _detailView.delegate = self;
        _detailView.dataSource = self;
        
        _detailView.layer.cornerRadius = 3;
        _detailView.layer.masksToBounds = YES;
    }
    return _detailView;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirm.backgroundColor = COLOR_THEME;
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _confirm.layer.cornerRadius = 3;
        _confirm.layer.masksToBounds = YES;
        [_confirm setTitle:@"信息无误，确认到厂" forState: UIControlStateNormal];
    }
    return _confirm;
}

-(UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.backgroundColor = [UIColor grayColor] ;
        [_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancel setTitle:@"取  消" forState: UIControlStateNormal];
        _cancel.layer.cornerRadius = 3;
        _cancel.layer.masksToBounds = YES;
        [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

-(WorkStatusView *)status
{
    if (!_status) {
        _status = [[WorkStatusView alloc] init];
        [_status setFrame:CGRectMake(5, 0, kScreen_Width-20-10, 44)];
    }
    return _status;
}

-(void)layout
{
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 140, 10);
    [self.detailView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
    [self.confirm makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailView.bottom).with.offset(10);
        make.bottom.equalTo(self.cancel.top).with.offset(-10);
        make.centerX.equalTo(self.detailView);
        make.left.equalTo(self).with.offset(10);
        make.height.equalTo(self.cancel);
        make.right.equalTo(self).with.offset(-10);
    }];
    [self.cancel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirm.bottom).with.offset(10);
        make.bottom.equalTo(self.bottom).with.offset(-10);
        make.centerX.equalTo(self.detailView);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
    }];
}

#pragma mark - tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return [titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableview"];
        [cell.contentView addSubview:self.status];
        [self.status setData:_detail.report];
        return cell;
    }
    else
    {
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
            report.detailLabel.text = _detail.truckno;
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
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] init];
    return header;
}

-(void)setDetail:(WorkDetail *)detail
{
    self->_detail = detail;
    [self.detailView reloadData];
}

-(void)cancel:(id)sender
{
    [self removeFromSuperview];
}
@end
