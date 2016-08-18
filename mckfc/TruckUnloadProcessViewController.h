//
//  TruckUnloadProcessViewController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkFlowInterface.h"

@interface TruckUnloadProcessViewController : WorkFlowInterface
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* confirm;

//在出厂时： 入厂重量-净重 == 出厂重量
@property (nonatomic, strong) NSNumber* weight; //入场重量
@property (nonatomic, strong) NSNumber* netWeight; //净重
@property (nonatomic, strong) NSNumber* finalWeight; //出场重量

@end
