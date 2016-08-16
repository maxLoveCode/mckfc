//
//  UserView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class UserView;

@protocol UserViewDelegate <NSObject>

-(void)didClickConfirm;
-(void)didTapAvatar;

@end

@interface UserView : UIView

@property (nonatomic, strong) UIButton* botBtn;
@property (weak, nonatomic) id <UserViewDelegate> delegate;

-(void)setContentByUser:(User* )user;

@end
