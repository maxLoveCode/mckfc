//
//  FarmerNav.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/5.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "FarmerNav.h"
#import "FarmerPlanViewController.h"

@interface FarmerNav()<UINavigationControllerDelegate>

@property (nonatomic, strong) FarmerPlanViewController* farmerVC;

@end

@implementation FarmerNav

-(instancetype)init
{
    _farmerVC = [[FarmerPlanViewController alloc] init];
    self = [super initWithRootViewController: self.farmerVC];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = COLOR_WithHex(0xf3f3f3);
    [self.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:COLOR_WithHex(0x878787)}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:COLOR_WithHex(0x878787)];
    
    return self;
}

@end