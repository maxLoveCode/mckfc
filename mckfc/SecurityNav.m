//
//  SecurityNav.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "SecurityNav.h"
#import "SecurityHomePage.h"

@interface SecurityNav()<UINavigationControllerDelegate>

@property (nonatomic, strong) SecurityHomePage* securityVC;

@end

@implementation SecurityNav

-(instancetype)init
{
    _securityVC = [[SecurityHomePage alloc] init];
    self = [super initWithRootViewController: self.securityVC];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = COLOR_WithHex(0xf3f3f3);
    [self.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:COLOR_WithHex(0x878787)}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:COLOR_WithHex(0x878787)];
    
    return self;
}

@end
