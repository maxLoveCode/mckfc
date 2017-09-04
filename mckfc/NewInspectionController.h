//
//  NewInspectionController.h
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/24.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkFlow.h"
@interface NewInspectionController : UITableViewController
@property (nonatomic, strong) WorkFlow* workFlow;
@property (nonatomic, assign) NSString* transportid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *mainType;
@property (nonatomic, assign) BOOL ischecked;


@end
