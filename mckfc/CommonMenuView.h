//
//  CommonMenuView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuViewStyle) {
    MenuViewStyleSecurityCheck,
    MenuViewStyleQualityCheck,
};

@class CommonMenuView;

@protocol MenuDelegate <NSObject>

-(void)CommonMenuView:(CommonMenuView*)menu didSelectWorkRecordWithType:(MenuViewStyle)style;
-(void)CommonMenuView:(CommonMenuView*)menu didSelectTODOWithType:(MenuViewStyle)style;
-(void)CommonMenuView:(CommonMenuView *)menu didSelectScanQRCode:(MenuViewStyle)style withIndex:(NSInteger)index;
-(void)CommonMenuView:(CommonMenuView*)menu didSelectSettingWithType:(MenuViewStyle)style;

@end

@interface CommonMenuView : UICollectionView

@property (nonatomic, assign) MenuViewStyle style;
@property (nonatomic, weak) id<MenuDelegate> menudelegate;

-(instancetype)initWithStyle:(MenuViewStyle)style;

@end
