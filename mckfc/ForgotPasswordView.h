//
//  ForgotPassword.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordView : UIView

@property (nonatomic, strong) UITextField* mobile;
@property (nonatomic, strong) UITextField* code;
@property (nonatomic, strong) UITextField* password;
@property (nonatomic, strong) UITextField* repass;

@property (nonatomic, strong) UIButton* vericode;
@property (nonatomic, strong) UIButton* confirm;

@end
