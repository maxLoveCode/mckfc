//
//  AlertHUDView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertHUDView;

@interface AlertHUDView : UIView

@property (nonatomic, strong) UIView* mask;

@property (nonatomic, strong) UIView* wrapperView;

@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* detail;

@end
