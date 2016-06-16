//
//  SignUpViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "SignUpViewController.h"
#import "ServerManager.h"
#import "SignUpView.h"
#import "VerifyViewController.h"
@interface SignUpViewController()<UITextFieldDelegate>
{
    NSString* defaultText;
}

@property (nonatomic, strong) SignUpView* signUpView;
@property (strong, nonatomic) ServerManager* server;
@end

@implementation SignUpViewController

-(void)viewDidLoad
{
    self.title = @"注册";
    
    defaultText  = @"请输入手机号";
    _server = [ServerManager sharedInstance];
    
    self.view = self.signUpView;

}

#pragma mark setter
-(SignUpView *)signUpView
{
    if (!_signUpView) {
        _signUpView = [[SignUpView alloc] init];
        [_signUpView.confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _signUpView.mobile.text = defaultText;
        _signUpView.mobile.delegate = self;
    }
    return _signUpView;
}


-(void)confirmBtn
{
    [_signUpView.mobile resignFirstResponder];
    NSDictionary* params = @{@"mobile":_signUpView.mobile.text};
    [_server POST:@"sendCaptcha" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if([responseObject[@"code"] integerValue] == 10010)
        {
            VerifyViewController* verifyVC = [[VerifyViewController alloc] init];
            [self.navigationController pushViewController:verifyVC animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:defaultText]) {
        textField.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = defaultText;
    }
}

@end
