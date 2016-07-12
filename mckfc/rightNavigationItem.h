//
//  rightNavigationItem.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/12.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rightNavigationItem : UIBarButtonItem <UITableViewDataSource, UITableViewDelegate>

-(instancetype)initCutomItem;

@property (nonatomic, strong) UITableView* popMenu;
@property (nonatomic, strong) UIView* mask;

@end
