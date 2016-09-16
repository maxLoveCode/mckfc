//
//  ChangePassView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/9/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassView : UIView

@property (nonatomic, strong) UITextField* oldpass;
@property (nonatomic, strong) UITextField* newpass;
@property (nonatomic, strong) UITextField* repass;


@property (nonatomic, strong) UIButton* confirm;

@end
