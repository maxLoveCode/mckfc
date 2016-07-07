//
//  SecurityHomePage.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "SecurityHomePage.h"
#import "CommonUserView.h"

@interface SecurityHomePage ()

@property (nonatomic, strong) CommonUserView* userView;

@end

@implementation SecurityHomePage

-(void)viewDidLoad
{
    _userView = [[CommonUserView alloc] init];
    self.view = _userView;
}

@end
