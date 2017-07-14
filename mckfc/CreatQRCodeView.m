//
//  CreatQRCodeView.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/11.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "CreatQRCodeView.h"
#import "CarDriverInfoCell.h"
#import "FarmerViewModel.h"
#import "TruckListModel.h"
NSString *cellID = @"cellID";
@interface CreatQRCodeView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) FarmerViewModel *farmerVM;
@end

@implementation CreatQRCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (FarmerViewModel *)farmerVM{
    if (!_farmerVM) {
        self.farmerVM = [[FarmerViewModel alloc]init];
    }
    return _farmerVM;
}

- (void)setNumberCode:(NSString *)numberCode{
    _numberCode = numberCode;
    [self.farmerVM getTruckListData:numberCode :^(NSString *msg){
        [self reloadData];
    }];
    
}

- (void)setDataArray:(NSArray *)dataArray{
    ;
    [self reloadData];
    
}

- (void)setupUI{
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"CarDriverInfoCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = self;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.farmerVM.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      CarDriverInfoCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.model = self.farmerVM.dataSource[indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.uploadImgDelegate && [self.uploadImgDelegate respondsToSelector:@selector(didClickUpdateImg:)]) {
        TruckListModel *model = self.farmerVM.dataSource[indexPath.row];
        [self.uploadImgDelegate didClickUpdateImg:[NSString stringWithFormat:@"%@",model.ID]];
    }
}




@end
