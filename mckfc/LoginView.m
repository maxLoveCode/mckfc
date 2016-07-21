//
//  LoginView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoginView.h"

#define topMargin 66
#define buttonHeight 40
#define buttonWidth kScreen_Width-4*k_Margin

@interface LoginView ()
{
    UIColor* textFieldColor;
}

@end

@implementation LoginView
-(instancetype)init
{
    if (self = [super init]) {
        textFieldColor = [UIColor colorWithWhite:1 alpha:0.33];
        
        [self addSubview:self.mobile];
        [self addSubview:self.password];
        [self addSubview:self.login];
        
        
        //[self addSubview:self.label];
        [self addSubview:self.signUp];

        //[self addSubview:self.fogetPassword];
    }
    return self;
}

#pragma mark setter
-(UITextField *)mobile
{
    if (!_mobile) {
        _mobile = [[UITextField alloc] init];
        [_mobile setBackgroundColor:textFieldColor];
        _mobile.layer.cornerRadius = 3;
        _mobile.layer.masksToBounds = YES;
        _mobile.tag = 1;
        _mobile.textColor = [UIColor whiteColor];
        _mobile.textAlignment = NSTextAlignmentCenter;
        _mobile.keyboardType = UIKeyboardTypePhonePad;
    }
    return _mobile;
}

-(UITextField *)password
{
    if (!_password) {
        _password = [[UITextField alloc] init];
        [_password setBackgroundColor:textFieldColor];
        _password.layer.cornerRadius = 3;
        _password.layer.masksToBounds = YES;
        _password.tag = 2;
        _password.textColor = [UIColor whiteColor];
        _password.textAlignment = NSTextAlignmentCenter;
        _password.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _password;
}

-(UIButton *)login
{
    if (!_login) {
        _login = [UIButton buttonWithType:UIButtonTypeCustom];
        [_login setTitle:@"登  录" forState:UIControlStateNormal];
        [_login setBackgroundColor:COLOR_THEME];
        [_login setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _login.layer.cornerRadius = 3;
        _login.layer.masksToBounds = YES;
        [_login addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login;
}

-(UIButton *)signUp
{
    if (!_signUp) {
        _signUp  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signUp setTitle:@"注册账号"  forState: UIControlStateNormal];
        [_signUp setBackgroundColor:[UIColor clearColor]];
        _signUp.titleLabel.font = [UIFont systemFontOfSize:15];
        [_signUp addTarget:self action:@selector(signUpBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUp;
}

-(UIButton *)fogetPassword
{
    if (!_fogetPassword) {
        _fogetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fogetPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fogetPassword setTitle:@"忘记密码"  forState: UIControlStateNormal];
        [_fogetPassword setBackgroundColor:[UIColor clearColor]];
        _fogetPassword.titleLabel.font = [UIFont systemFontOfSize:15];
        [_fogetPassword addTarget:self action:@selector(reClaimPass) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fogetPassword;
}


-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:[UIColor whiteColor]];
    }
    return _label;
}

#pragma mark subviews
-(void)layoutSubviews
{
    CGRect frame = CGRectMake(2*k_Margin, topMargin, buttonWidth, buttonHeight);
    [self.mobile setFrame:frame];
    [self.password setFrame:CGRectOffset(self.mobile.frame, 0, buttonHeight*2)];
    [self.login setFrame:CGRectOffset(self.password.frame, 0, buttonHeight*2)];
//button width = 80
//length to mid = 10
    
    [self.signUp setFrame:CGRectMake((kScreen_Width/2 - 80-10), kScreen_Height-topMargin-15 -44 , 80, 19)];
    [self.fogetPassword setFrame:CGRectOffset(self.signUp.frame, 80+10*2, 0)];
    
    [self.label setFrame:CGRectMake(CGRectGetMaxX(self.signUp.frame)+9, CGRectGetMinY(self.signUp.frame), 1, CGRectGetHeight(self.signUp.frame))];
    
    self.signUp.center = CGPointMake(kScreen_Width/2, self.signUp.frame.origin.y+9);
}



#pragma mark button selectors
-(void)loginBtn
{
    [self.delegate didSelectLoginWithMobile:self.mobile.text Password:self.password.text];
}

-(void)signUpBtn
{
    [self.delegate didSelectSignUp];
}

-(void)reClaimPass
{
    [self.delegate didSelectReclaimPassword];
}
@end
