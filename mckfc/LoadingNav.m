//
//  LoadingNav.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
//  装载页面


#import "LoadingNav.h"
#import "HomepageViewController.h"

@interface LoadingNav()<UINavigationControllerDelegate>

@property (nonatomic, strong) HomepageViewController* loadVC;

@end

@implementation LoadingNav

-(instancetype)init
{
    _loadVC = [[HomepageViewController alloc] init];
    if (self = [super initWithRootViewController: self.loadVC]) {
        self.delegate = self;
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = COLOR_WithHex(0xf3f3f3);
        [self.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:COLOR_WithHex(0x878787)}];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)dismissAllModalViews
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self popToRootViewControllerAnimated:NO];
}

@end
