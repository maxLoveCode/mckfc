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
#define buttonWidth 300

@implementation LoginView

#pragma mark setter
-(UITextField *)mobile
{
    if (!_mobile) {
        _mobile = [[UITextField alloc] init];
    }
    return _mobile;
}

-(UITextField *)password
{
    if (!_password) {
        _password = [[UITextField alloc] init];
    }
    return _password;
}

-(UIButton *)login
{
    if (!_login) {
        _login  = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _login;
}

-(UIButton *)signUp
{
    if (!_signUp) {
        _signUp  = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _signUp;
}

-(UIButton *)fogetPassword
{
    if (!_fogetPassword) {
        _fogetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _fogetPassword;
}

-(UIImageView *)bgView
{
    if(!_bgView){
        _bgView = [[UIImageView alloc] init];
    }
    return _bgView;
}

-(void)layoutSubviews
{
    CGRect frame = CGRectMake((kScreen_Width - buttonWidth)/2, topMargin, buttonWidth, buttonHeight);
    [self.mobile setFrame:frame];
    [self.password setFrame:CGRectOffset(self.mobile.frame, 0, buttonHeight*2)];
    [self.login setFrame:CGRectOffset(self.password.frame, 0, buttonHeight*2)];
    
    [self.bgView addSubview:self.mobile];
    [self.bgView addSubview:self.password];
    [self.bgView addSubview:self.login];
    
    [self addSubview:self.bgView];
}
@end
