//
//  LoginViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController()

@property (strong, nonatomic) LoginView* loginView;

@end


@implementation LoginViewController

-(void)viewDidLoad
{
    self.view = self.loginView;
}

-(LoginView *)loginView
{
    if (!_loginView) {
        _loginView = [[LoginView alloc] init];
    }
    return _loginView;
}

@end
