//
//  QualityControlHomePage.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QualityControlHomePage.h"
#import "CommonUserView.h"

@interface QualityControlHomePage ()

@property (nonatomic, strong) CommonUserView* userView;

@end

@implementation QualityControlHomePage

-(void)viewDidLoad
{
    _userView = [[CommonUserView alloc] init];
    self.view = _userView;
}

@end
