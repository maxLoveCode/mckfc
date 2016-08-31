//
//  ForgotPassword.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ForgotPasswordView.h"

#define topMargin 66
#define buttonHeight 40
#define buttonWidth kScreen_Width-4*k_Margin

@implementation ForgotPasswordView
{
    UIColor* textFieldColor;
}


-(instancetype)init
{
    self = [super init];
    
    
    textFieldColor = [UIColor colorWithWhite:1 alpha:0.33];
    
    [self addSubview:self.mobile];
    [self addSubview:self.code];
    [self addSubview:self.repass];
    [self addSubview:self.password];
    
    [self addSubview:self.vericode];
    [self addSubview:self.confirm];
    
    [self layout];
    
    return self;
}

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

-(UITextField *)code
{
    if (!_code) {
        _code = [[UITextField alloc] init];
        [_code setBackgroundColor:textFieldColor];
        _code.layer.cornerRadius = 3;
        _code.layer.masksToBounds = YES;
        _code.tag = 2;
        _code.textColor = [UIColor whiteColor];
        _code.textAlignment = NSTextAlignmentCenter;
        _code.keyboardType = UIKeyboardTypePhonePad;
    }
    return _code;
}

-(UITextField *)password
{
    if (!_password) {
        _password = [[UITextField alloc] init];
        [_password setBackgroundColor:textFieldColor];
        _password.layer.cornerRadius = 3;
        _password.layer.masksToBounds = YES;
        _password.tag = 3;
        _password.textColor = [UIColor whiteColor];
        _password.textAlignment = NSTextAlignmentCenter;
        _password.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _password;
}

-(UITextField *)repass
{
    if (!_repass) {
        _repass = [[UITextField alloc] init];
        [_repass setBackgroundColor:textFieldColor];
        _repass.layer.cornerRadius = 3;
        _repass.layer.masksToBounds = YES;
        _repass.tag = 4;
        _repass.textColor = [UIColor whiteColor];
        _repass.textAlignment = NSTextAlignmentCenter;
        _repass.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _repass;
}

-(UIButton *)vericode
{
    if (!_vericode) {
        _vericode = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vericode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_vericode setBackgroundColor:COLOR_THEME];
        [_vericode setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _vericode.layer.cornerRadius = 3;
        _vericode.layer.masksToBounds = YES;
        [_vericode setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }
    return _vericode;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"确  认" forState:UIControlStateNormal];
        [_confirm setBackgroundColor:COLOR_THEME];
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _confirm.layer.cornerRadius = 3;
        _confirm.layer.masksToBounds = YES;
    }
    return _confirm;
}

-(void)layout
{
    CGSize buttonSize = CGSizeMake(buttonWidth, buttonHeight);
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreen_Width, kScreen_Height));
    }];
    
    [self.mobile makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.top).offset(topMargin+64);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.code makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(buttonWidth-130, buttonHeight));
        make.top.equalTo(self.mobile.bottom).with.offset(buttonHeight);
        make.left.equalTo(self.mobile.left);
    }];
    
    [self.password makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.code.bottom).with.offset(buttonHeight);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.repass makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.password.bottom).with.offset(buttonHeight);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.vericode makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(110, buttonHeight));
        make.top.equalTo(self.code.top);
        make.right.equalTo(self.mobile.right);
    }];
    
    [self.confirm makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.password.bottom).with.offset(buttonHeight);
        make.centerX.equalTo(self.centerX);
    }];
}

@end
