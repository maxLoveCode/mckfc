//
//  ForgotPasswordViewController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotPasswordView.h"

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) ForgotPasswordView* forgotPassView;

@end
