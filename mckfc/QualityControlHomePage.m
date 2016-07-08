//
//  QualityControlHomePage.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QualityControlHomePage.h"
#import "CommonUserView.h"
#import "CommonMenuView.h"
#import "WorkRecordViewController.h"

@interface QualityControlHomePage () <CommonUserViewDelegate>

@property (nonatomic, strong) CommonUserView* userView;

@end

@implementation QualityControlHomePage

-(void)viewDidLoad
{
    _userView = [[CommonUserView alloc] init];
    _userView.delegate = self;
    self.view = _userView;
}

-(void)navigateToWorkRecord
{
    WorkRecordViewController *WRVC = [[WorkRecordViewController alloc] init];
    [self.navigationController pushViewController:WRVC animated:YES];
}
@end
