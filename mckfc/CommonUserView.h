//
//  CommonUserView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMenuView.h"
#import "User.h"

@class CommonUserView;

@protocol CommonUserViewDelegate <NSObject>

-(void)navigateToWorkRecord;
-(void)navigateToQRScannerWithItem:(NSInteger)item;
-(void)didTapAvatar;

@end

@interface CommonUserView : UIView

@property (strong, nonatomic) CommonMenuView* menu;
@property (strong, nonatomic) User* user;

@property (strong, nonatomic) UITableView* mainTableView;

@property (weak, nonatomic) id<CommonUserViewDelegate> delegate;

@end
