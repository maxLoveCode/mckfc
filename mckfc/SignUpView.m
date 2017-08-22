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
        [self addSubview:self.repeatmobile];
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

-(UITextField *)repeatmobile
{
    if (!_repeatmobile) {
        _repeatmobile = [[UITextField alloc] init];
        [_repeatmobile setBackgroundColor:textFieldColor];
        _repeatmobile.layer.cornerRadius = 3;
        _repeatmobile.layer.masksToBounds = YES;
        _repeatmobile.textColor = [UIColor whiteColor];
        _repeatmobile.textAlignment = NSTextAlignmentCenter;
        _repeatmobile.keyboardType = UIKeyboardTypePhonePad;
    }
    return _repeatmobile;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"确定" forState:UIControlStateNormal];
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
    CGRect repeatframe = CGRectMake(2*k_Margin, topMargin + 70, buttonWidth, buttonHeight);
    [self.mobile setFrame:frame];
    [self.repeatmobile setFrame:repeatframe];
    [self.confirm setFrame:CGRectOffset(self.repeatmobile.frame, 0, buttonHeight*2)];
}

@end
