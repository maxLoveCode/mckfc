//
//  CommonUserView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMenuView.h"

@class CommonUserView;

@protocol CommonUserViewDelegate <NSObject>

-(void)navigateToWorkRecord;
-(void)navigateToQRScanner;

@end

@interface CommonUserView : UIView

@property (strong, nonatomic) CommonMenuView* menu;

@property (weak, nonatomic) id<CommonUserViewDelegate> delegate;

@end
