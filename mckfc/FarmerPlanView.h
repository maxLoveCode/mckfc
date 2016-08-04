//
//  FarmerPlanView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FarmerQRCodeView.h"

@class FarmerPlanView;

typedef NS_ENUM(NSUInteger, PlanViewType) {
    FarmerPlanViewTypeMenu,
    FarmerPlanViewTypeQRCode,
    FarmerPlanViewTypeOrder,
};

@protocol FarmerPlanViewDelegate <NSObject>

-(void)menuDidSelectIndex:(NSInteger)index;

@end
       

@interface FarmerPlanView : UIView

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic) PlanViewType type;
@property (nonatomic, strong) FarmerQRCodeView* qrCodeView;
@property (nonatomic, weak) id<FarmerPlanViewDelegate> delegate;

@end
