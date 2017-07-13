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
#import "FarmerViewModel.h"
NSString *cellID = @"cellID";
NSString *qrCreatCellID = @"qrCreatCellID";
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
    [self registerNib:[UINib nibWithNibName:@"QRCreatCell" bundle:nil] forCellReuseIdentifier:qrCreatCellID];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshTruckList" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)refreshData{
    [self.farmerVM getTruckListData:self.numberCode :^(NSString *msg){
        [self reloadData];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
        ;
    }else{
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.farmerVM.dataSource.count;
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
        cell.model = self.farmerVM.dataSource[indexPath.row];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.clickDelegate didClickPushController];
    }
}



@end
