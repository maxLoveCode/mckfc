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
@property (nonatomic, strong) NSNumber* weight;

@end
