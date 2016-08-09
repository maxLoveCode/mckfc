//
//  FarmerRecordCell.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/9.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "LoadingStats.h"

@interface FarmerRecordCell : UITableViewCell

@property (nonatomic, strong) UILabel* title;

@property (nonatomic, strong) NSDictionary* content;

+(CGFloat)cellHeight;

@end
