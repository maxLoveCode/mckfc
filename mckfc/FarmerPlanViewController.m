//
//  FarmerPlanViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "FarmerPlanViewController.h"
#import "FarmerPlanView.h"

#import "FarmerQRCodeVC.h"

@interface FarmerPlanViewController ()<FarmerPlanViewDelegate>

@property (nonatomic, strong) FarmerPlanView* farmerPlanview;

@end

@implementation FarmerPlanViewController

-(void)viewDidLoad
{
    self.view = self.farmerPlanview;
}

-(FarmerPlanView *)farmerPlanview
{
    if (!_farmerPlanview) {
        _farmerPlanview = [[FarmerPlanView alloc] init];
        _farmerPlanview.delegate = self;
    }
    return _farmerPlanview;
}

-(void)menuDidSelectIndex:(NSInteger)index
{
    FarmerQRCodeVC* QRVC = [[FarmerQRCodeVC alloc] init];
    [self addChildViewController:QRVC];
    _farmerPlanview.qrCodeView = (FarmerQRCodeView*)QRVC.view;
    [_farmerPlanview.mainTableView reloadData];
}

@end
