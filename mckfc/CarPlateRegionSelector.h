//
//  CarPlateRegionSelector.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/13.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarPlateRegionSelector : UICollectionView

@property (nonatomic, strong) NSArray* regions;
@property (nonatomic, strong) void(^selectBlock)(NSString*);

-(void)show;

@end
