//
//  ReportCollectionView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/1.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface ReportCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) Report* report;

-(instancetype)init;

@end
