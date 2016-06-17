//
//  VerifyView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyView : UIView

@property (nonatomic, strong) UITextField* code;
@property (nonatomic, strong) UITextField* password;

@property (nonatomic, strong) UIButton* resend;
@property (nonatomic, strong) UILabel* label;

@property (nonatomic, strong) UIButton* confirm;

@end
