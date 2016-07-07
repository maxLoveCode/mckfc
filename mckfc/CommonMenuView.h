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

@interface CommonMenuView : UICollectionView

@property (nonatomic, assign) MenuViewStyle style;

-(instancetype)initWithStyle:(MenuViewStyle)style;

@end
