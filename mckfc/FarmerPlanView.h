//
//  FarmerPlanView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FarmerQRCodeView.h"

#import "LoadingStats.h"

@class FarmerPlanView;

typedef NS_ENUM(NSUInteger, PlanViewType) {
    FarmerPlanViewTypeMenu, //菜单
    FarmerPlanViewTypeQRCode, //二维码页面
    FarmerPlanViewTypeOrder,  //添加运输单页
    FarmerPlanViewTypeRecordList, //运输单页列表
};

@protocol FarmerPlanViewDelegate <NSObject>

-(void)menu:(FarmerPlanView*)Menu DidSelectIndex:(NSInteger)index;
-(void)tableStats:(UITableView*)table DidSelectIndex:(NSInteger)index;

@end
       

@interface FarmerPlanView : UIScrollView

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic) PlanViewType type;

@property (nonatomic, strong) FarmerQRCodeView* qrCodeView;
@property (nonatomic, strong) UITableView* addRecordView;

@property (nonatomic, weak) id<FarmerPlanViewDelegate> planViewDelegate;

@property (nonatomic, strong) LoadingStats* stats;
@property (nonatomic, strong) NSArray* datasource; //order list;

@end
