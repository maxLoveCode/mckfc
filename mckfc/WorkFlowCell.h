//
//  WorkFlowCell.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/9.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkFlow.h"

@interface WorkFlowCell : UITableViewCell

@property (nonatomic, strong) UIImageView* indicator;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* detailLabel;
@property (nonatomic, strong) UILabel* timeLabel;

@property (nonatomic, strong) WorkFlow* workFlow;

+(CGFloat)cellHeight;

@end
