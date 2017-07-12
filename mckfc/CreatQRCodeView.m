//
//  CreatQRCodeView.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/11.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CreatQRCodeView.h"
#import "QRCreatCell.h"
#import "CarDriverInfoCell.h"

NSString *cellID = @"cellID";
NSString *qrCreatCellID = @"qrCreatCellID";
@interface CreatQRCodeView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CreatQRCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

- (void)setupUI{
    self.dataSource = self;
      [self registerNib:[UINib nibWithNibName:@"CarDriverInfoCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self registerNib:[UINib nibWithNibName:@"QRCreatCell" bundle:nil] forCellReuseIdentifier:qrCreatCellID];
    self.delegate = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return  10;
    }
    return  0.1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:qrCreatCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
      CarDriverInfoCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.clickDelegate didClickPushController];
    }else{
        TruckListModel *model = self.dataArray[indexPath.row];
        if (model.mobile && ![model.mobile isEqualToString:@""]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.mobile]]];
        }else{
          
        }
    }
}



@end
