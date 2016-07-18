//
//  WorkFlowInterface.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkFlow.h"

@interface WorkFlowInterface : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) WorkFlow* workFlow;

@end
