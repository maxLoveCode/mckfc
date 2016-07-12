//
//  SignUpView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "SignUpView.h"

#define topMargin 66
#define buttonHeight 40
#define buttonWidth kScreen_Width-4*k_Margin

@interface SignUpView ()
{
    UIColor* textFieldColor;
}

@end

@implementation SignUpView

-(instancetype)init
{
    if (self = [super init]) {
        textFieldColor = [UIColor colorWithWhite:1 alpha:0.33];
        
        [self addSubview:self.mobile];
        [self addSubview:self.confirm];
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
        _mobile.textColor = [UIColor whiteColor];
        _mobile.textAlignment = NSTextAlignmentCenter;
        _mobile.keyboardType = UIKeyboardTypePhonePad;
    }
    return _mobile;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_confirm setBackgroundColor:COLOR_THEME];
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        _confirm.layer.cornerRadius = 3;
        _confirm.layer.masksToBounds = YES;
        
    }
    return _confirm;
}

-(void)layoutSubviews
{
    CGRect frame = CGRectMake(2*k_Margin, topMargin, buttonWidth, buttonHeight);
    [self.mobile setFrame:frame];
    [self.confirm setFrame:CGRectOffset(self.mobile.frame, 0, buttonHeight*2)];
}

@end
