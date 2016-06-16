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
        
        [self addSubview:self.code];
        [self addSubview:self.resend];
        [self addSubview:self.password];
    }
    return self;
}

#pragma mark setter
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
    }
    return _code;
}

-(void)layoutSubviews
{
    CGRect frame = CGRectMake((kScreen_Width - buttonWidth)/2, topMargin, buttonWidth, buttonHeight);
    [self.code setFrame:frame];
    [self.password setFrame:CGRectOffset(self.code.frame, 0, buttonHeight*2)];
}
@end
