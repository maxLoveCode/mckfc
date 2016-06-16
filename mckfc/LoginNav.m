//
//  LoginNav.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoginNav.h"
#import "LoginViewController.h"

@interface LoginNav ()<UINavigationControllerDelegate>

@property (nonatomic, strong) LoginViewController* loginVC;
@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation LoginNav

-(instancetype)init
{
    _loginVC = [[LoginViewController alloc] init];
    if (self = [super initWithRootViewController: self.loginVC]) {
        self.delegate = self;
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = COLOR_WithHex(0xf3f3f3);
        [self.navigationBar setTitleTextAttributes:
        @{NSForegroundColorAttributeName:COLOR_WithHex(0x878787)}];
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _imageView.image = [UIImage imageNamed:@"login_bg"];
        [self.view insertSubview:_imageView  atIndex:0];
    }
    return self;
}


#pragma mark gesture
-(void)dismissKeyboard
{
    
}

@end
