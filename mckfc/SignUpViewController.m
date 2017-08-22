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
#import "AlertHUDView.h"
@interface SignUpViewController()<UITextFieldDelegate,HUDViewDelegate>
{
    NSString* defaultText;
    NSString* _repeatdefaultText;
}

@property (nonatomic, strong) SignUpView* signUpView;
@property (strong, nonatomic) ServerManager* server;
@property AlertHUDView *alert;
@end

@implementation SignUpViewController

-(void)viewDidLoad
{
    self.title = @"注册";
    
    defaultText  = @"请输入手机号";
    _repeatdefaultText = @"请再次输入手机号";
    _server = [ServerManager sharedInstance];
    
    self.view = self.signUpView;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view setAlpha:0];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setAlpha:1];
}

#pragma mark setter
-(SignUpView *)signUpView
{
    if (!_signUpView) {
        _signUpView = [[SignUpView alloc] init];
        [_signUpView.confirm addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
        _signUpView.mobile.text = defaultText;
        _signUpView.repeatmobile.text = _repeatdefaultText;
        _signUpView.mobile.delegate = self;
        _signUpView.repeatmobile.delegate = self;
    }
    return _signUpView;
}


-(void)confirmBtn
{
    if (![_signUpView.mobile.text isEqualToString:@""] && [_signUpView.mobile.text isEqualToString:_signUpView.repeatmobile.text]) {
        VerifyViewController* verifyVC = [[VerifyViewController alloc] init];
                    verifyVC.mobile = _signUpView.mobile.text;
                    [verifyVC setText:_signUpView.mobile.text];
                    [self.navigationController pushViewController:verifyVC animated:YES];
    }else{
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.title.text = @"确认输入手机号";
        _alert.detail.text = @"请确保两次输入手机号完全一样";
        _alert.delegate = self;
        [_alert show:_alert];

    }
//    [_signUpView.mobile resignFirstResponder];
//    NSDictionary* params = @{@"mobile":_signUpView.mobile.text};
//    [_server POST:@"sendRegisterCaptcha" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        if([responseObject[@"code"] integerValue] == 10000)
//        {
//            VerifyViewController* verifyVC = [[VerifyViewController alloc] init];
//            verifyVC.mobile = _signUpView.mobile.text;
//            [verifyVC setText:_signUpView.mobile.text];
//            [self.navigationController pushViewController:verifyVC animated:YES];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:defaultText] || [textField.text isEqualToString:_repeatdefaultText]) {
        textField.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = defaultText;
    }
}

- (void)didSelectConfirm{
     [self.alert removeFromSuperview];
}

#pragma mark gesture
-(void)dismissKeyboard
{
    [_signUpView.mobile resignFirstResponder];
}


@end
