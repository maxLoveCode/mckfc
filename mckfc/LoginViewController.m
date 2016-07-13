//
//  LoginViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerManager.h"
#import "SignUpViewController.h"

#import "NSString+MD5.h"

@interface LoginViewController()<UITextFieldDelegate, LoginViewDelegate>
{
    NSArray* defaultText;
}

@property (strong, nonatomic) LoginView* loginView;
@property (strong, nonatomic) ServerManager* server;

@end


@implementation LoginViewController

-(void)viewDidLoad
{
    self.title = @"登录";
    defaultText = @[@"请输入手机号", @"请输入密码"];
    
    _server = [ServerManager sharedInstance];
    
    self.view = self.loginView;
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
-(LoginView *)loginView
{
    if (!_loginView) {
        _loginView = [[LoginView alloc] init];
        _loginView.delegate = self;
        for (int i=0; i<defaultText.count; i++) {
            UIView* view = [_loginView viewWithTag:i+1];
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField* textField = (UITextField*)view;
                textField.text = defaultText[i];
                textField.delegate = self;
            }
        }
    }
    return _loginView;
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:defaultText[textField.tag-1]]) {
        textField.text = @"";
    }
    if (textField.tag == 2) {
        textField.secureTextEntry = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        if (textField.tag == 2) {
            textField.secureTextEntry = NO;
        }
        textField.text = defaultText[textField.tag-1];
    }
}

#pragma mark loginView delegate
-(void)didSelectLoginWithMobile:(NSString *)mobile Password:(NSString *)password
{
    [self dismissKeyboard];
    NSDictionary* params = @{@"username":mobile,
                             @"password":password};
    [_server POST:@"login" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 10000) {
            NSLog(@"%@",responseObject);
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject[@"data"] objectForKey:@"token"] forKey:@"access_token"];
            _server.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]);
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)didSelectSignUp
{
    SignUpViewController* SignUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:SignUpVC animated:YES];
}

-(void)didSelectReclaimPassword
{
    
}


#pragma mark gesture
-(void)dismissKeyboard
{
    [_loginView.mobile resignFirstResponder];
    [_loginView.password resignFirstResponder];
}


@end
