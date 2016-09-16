//
//  ChangePassView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/9/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ChangePassView.h"

#define topMargin 66
#define buttonHeight 40
#define buttonWidth kScreen_Width-4*k_Margin

@implementation ChangePassView
{
    UIColor* textFieldColor;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    textFieldColor = [UIColor colorWithWhite:1 alpha:0.33];
    if (self) {
        [self addSubview:self.newpass];
        [self addSubview:self.oldpass];
        [self addSubview:self.repass];
        [self addSubview:self.confirm];
    }
    return self;
}

-(UITextField *)newpass
{
    if (!_newpass) {
        _newpass = [[UITextField alloc] init];
        [_newpass setBackgroundColor:textFieldColor];
        _newpass.tag = 2;
        _newpass.layer.cornerRadius = 3;
        _newpass.layer.masksToBounds = YES;
        _newpass.textColor = [UIColor whiteColor];
        _newpass.textAlignment = NSTextAlignmentCenter;
        _newpass.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _newpass;
}

-(UITextField *)oldpass
{
    if (!_oldpass) {
        _oldpass = [[UITextField alloc] init];
        [_oldpass setBackgroundColor:textFieldColor];
        _oldpass.tag = 1;
        _oldpass.layer.cornerRadius = 3;
        _oldpass.layer.masksToBounds = YES;
        _oldpass.textColor = [UIColor whiteColor];
        _oldpass.textAlignment = NSTextAlignmentCenter;
        _oldpass.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _oldpass;
}

-(UITextField *)repass
{
    if (!_repass) {
        _repass = [[UITextField alloc] init];
        [_repass setBackgroundColor:textFieldColor];
        _repass.tag = 3;
        _repass.layer.cornerRadius = 3;
        _repass.layer.masksToBounds = YES;
        _repass.textColor = [UIColor whiteColor];
        _repass.textAlignment = NSTextAlignmentCenter;
        _repass.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _repass;
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

-(void)updateConstraints
{
    CGSize buttonSize = CGSizeMake(buttonWidth, buttonHeight);
    [self.newpass makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.oldpass.bottom).with.offset(buttonHeight);
        make.centerX.equalTo(self.centerX);
    }];
    [self.repass makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.newpass.bottom).with.offset(buttonHeight);
        make.centerX.equalTo(self.centerX);
    }];
    [self.oldpass makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.top).offset(topMargin);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.confirm makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.top.equalTo(self.repass.bottom).with.offset(buttonHeight);
        make.centerX.equalTo(self.centerX);
    }];
    
    [super updateConstraints];
}
@end
