//
//  WorkRecordCell.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "workRecord.h"

@interface WorkRecordCell : UITableViewCell
@property (nonatomic, strong) UILabel* warehouse;
@property (nonatomic, strong) workRecord* record;

+(CGFloat)HeightForWorkRecordCell;

@end
