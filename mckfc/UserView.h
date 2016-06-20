//
//  UserView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserView;

@protocol UserViewDelegate <NSObject>

-(void)didClickConfirm;

@end

@interface UserView : UIView

@property (weak, nonatomic) id <UserViewDelegate> delegate;

@end
