//
//  VerifyView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "VerifyView.h"

#define topMargin 66
#define buttonHeight 40
#define buttonWidth 300

@interface VerifyView ()
{
    UIColor* textFieldColor;
}

@end

@implementation VerifyView

-(instancetype)init
{
    if (self = [super init]) {
        textFieldColor = [UIColor colorWithWhite:1 alpha:0.33];
        
       // [self addSubview:self.code];
        //[self addSubview:self.resend];
        [self addSubview:self.password];
        [self addSubview:self.repeatpassword];
        //[self addSubview:self.label];
        [self addSubview:self.confirm];
    }
    return self;
}

#pragma mark- setter
-(UITextField *)code
{
    if (!_code) {
        _code = [[UITextField alloc] init];
        [_code setBackgroundColor:textFieldColor];
        _code.layer.cornerRadius = 3;
        _code.layer.masksToBounds = YES;
        _code.textColor = [UIColor whiteColor];
        _code.textAlignment = NSTextAlignmentCenter;
        _code.keyboardType = UIKeyboardTypePhonePad;
        _code.tag = 1;
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
        _password.textColor = [UIColor whiteColor];
        _password.textAlignment = NSTextAlignmentCenter;
        _password.keyboardType = UIKeyboardTypeASCIICapable;
        _password.tag = 2;
    }
    return _password;
}

-(UITextField *)repeatpassword
{
    if (!_repeatpassword) {
        _repeatpassword = [[UITextField alloc] init];
        [_repeatpassword setBackgroundColor:textFieldColor];
        _repeatpassword.layer.cornerRadius = 3;
        _repeatpassword.layer.masksToBounds = YES;
        _repeatpassword.textColor = [UIColor whiteColor];
        _repeatpassword.textAlignment = NSTextAlignmentCenter;
        _repeatpassword.keyboardType = UIKeyboardTypeASCIICapable;
        _repeatpassword.tag = 2;
    }
    return _repeatpassword;
}

-(UIButton *)resend
{
    if (!_resend) {
        _resend = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resend setTitle:@"重新获取" forState:UIControlStateNormal];
        [_resend setBackgroundColor:COLOR_THEME];
        [_resend setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        
        _resend.layer.cornerRadius = 3;
        _resend.layer.masksToBounds = YES;
    }
    return _resend;
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:15];
    }
    return _label;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirm setBackgroundColor:COLOR_THEME];
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _confirm.layer.cornerRadius = 3;
        _confirm.layer.masksToBounds = YES;
    }
    return _confirm;
}

#pragma mark- layouts
-(void)layoutSubviews
{
    CGRect frame = CGRectMake((kScreen_Width - buttonWidth)/2, topMargin, buttonWidth, buttonHeight);
    [self.code setFrame:frame];
    [self.code setFrame:CGRectMake((kScreen_Width - buttonWidth)/2, topMargin, buttonWidth-130, buttonHeight)];
    [self.resend setFrame:CGRectMake(CGRectGetMaxX(self.code.frame)+20, CGRectGetMinY(self.code.frame), 110, buttonHeight)];
    
   
    [self.label setFrame:CGRectMake(0, 0, kScreen_Width, topMargin)];
    // [self.password setFrame:CGRectOffset(self.code.frame, 0, buttonHeight*2)];
    [self.password setFrame:CGRectMake(10, topMargin, kScreen_Width - 20, buttonHeight)];
     [self.repeatpassword setFrame:CGRectOffset(self.password.frame, 0, buttonHeight*2)];
     [self.confirm setFrame:CGRectOffset(self.repeatpassword.frame, 0, buttonHeight*2)];
}

@end
