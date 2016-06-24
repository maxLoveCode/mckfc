//
//  StatsView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

-(instancetype)initWithStats:(NSDictionary*)Stats;

-(void)setStatsFromDictionary:(NSDictionary* )stats;

@end
