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
#import "ForgotPasswordViewController.h"

#import "NSString+MD5.h"

//may change root view by usertype
#import "LoadingNav.h"
#import "SecurityNav.h"
#import "QualityControlNav.h"
#import "FarmerNav.h"

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
//saving access_token and user_type
            NSLog(@"login: %@", responseObject);
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject[@"data"] objectForKey:@"token"] forKey:@"access_token"];
            NSString* type = [NSString stringWithFormat:@"%@", [responseObject[@"data"] objectForKey:@"type"]];
            [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"user_type"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _server.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            
//            if([self switchRootView: type])
//            {
//                
//            }
//            else
//            {
//                [self dismissViewControllerAnimated:YES completion:^{
//                }];
//            }
            [self dismissViewControllerAnimated:NO completion:^{
                [self switchRootView:type];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)didSelectSignUp
{
    
    UIApplication* app = [UIApplication sharedApplication];
    UIViewController*root =  app.keyWindow.rootViewController;
    if(![root isKindOfClass:[LoadingNav class]]){
        LoadingNav* loadingNav = [[LoadingNav alloc] init];
        app.keyWindow.rootViewController = loadingNav;
    }
    
    SignUpViewController* SignUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:SignUpVC animated:YES];
    
}

-(void)didSelectReclaimPassword
{
    ForgotPasswordViewController* fpvc = [[ForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:fpvc animated:YES];
}

#pragma mark gesture
-(void)dismissKeyboard
{
    [_loginView.mobile resignFirstResponder];
    [_loginView.password resignFirstResponder];
}

#pragma mark app loginview
-(BOOL)switchRootView:(NSString*)type
{
    UIApplication* app = [UIApplication sharedApplication];
    UIViewController*root =  app.keyWindow.rootViewController;
    if ([type isEqualToString:MKUSER_TYPE_DRIVER]) {
        if(![root isKindOfClass:[LoadingNav class]]){
            LoadingNav* loadingNav = [[LoadingNav alloc] init];
            app.keyWindow.rootViewController = loadingNav;
            return YES;
        }
    }
    else if([type isEqualToString:MKUSER_TYPE_SECURITY]){
        if(![root isKindOfClass:[SecurityNav class]]){
            SecurityNav* securityNav = [[SecurityNav alloc] init];
            app.keyWindow.rootViewController = securityNav;
            
            return YES;
        }
    }
    else if([type isEqualToString:MKUSER_TYPE_UNLOAD] ||
            [type isEqualToString:MKUSER_TYPE_QUALITYCONTROL] ||
            [type isEqualToString:MKUSER_TYPE_QUALITYCONTROL2]){
        if(![root isKindOfClass:[QualityControlNav class]]){
            QualityControlNav* QCNav = [[QualityControlNav alloc] init];
            app.keyWindow.rootViewController = QCNav;
            
            return YES;
        }
    }
    else if([type isEqualToString:MKUSER_TYPE_FARMER])
    {
        if (![root isKindOfClass:[FarmerNav class]]) {
            FarmerNav* farmerNav = [[FarmerNav alloc] init];
            app.keyWindow.rootViewController = farmerNav;
        }
    }
    return NO;
}


@end
