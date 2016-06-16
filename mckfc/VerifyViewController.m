//
//  VerifyViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "VerifyViewController.h"
#import "ServerManager.h"
#import "VerifyView.h"

@interface VerifyViewController()<UITextFieldDelegate>
{
    NSString* defaultText;
}

@property (nonatomic, strong) VerifyView* verifyView;
@property (strong, nonatomic) ServerManager* server;
@end

@implementation VerifyViewController

-(void)viewDidLoad
{
    self.title = @"输入验证码";
    
    defaultText  = @"请输入手机号";
    _server = [ServerManager sharedInstance];
    
    self.view = self.verifyView;
}

#pragma mark setter
-(VerifyView *)verifyView
{
    if (!_verifyView) {
        _verifyView = [[VerifyView alloc] init];
    }
    return _verifyView;
}

@end
