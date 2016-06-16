//
//  LoginView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginView;

@protocol LoginViewDelegate <NSObject>

-(void)didSelectLoginWithMobile:(NSString* )mobile Password:(NSString* )password;
-(void)didSelectSignUp;
-(void)didSelectReclaimPassword;

@end


@interface LoginView : UIView

@property (strong, nonatomic) UITextField* mobile;
@property (strong, nonatomic) UITextField* password;
@property (strong, nonatomic) UIButton* login;
@property (strong, nonatomic) UIButton* signUp;
@property (strong, nonatomic) UIButton* fogetPassword;

@property (strong, nonatomic) UILabel* label;

@property (nonatomic, weak) id <LoginViewDelegate> delegate;
@end
