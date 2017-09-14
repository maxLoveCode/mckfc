//
//  WorkDetailViewController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDetailViewController.h"
#import "orderGeneralReport.h"
#import "WorkFlowCell.h"
#import "WorkFlow.h"

#import "ServerManager.h"
#import "WorkDetail.h"

#import "UIImageView+Webcache.h"

#import "TruckUnloadProcessViewController.h"
#import "QualityCheckViewController.h"
#import "InspectionViewController.h"

@interface WorkDetailViewController : UIViewController

@property (nonatomic, strong, nonnull) NSString* transportid;
@property (nonatomic, assign) BOOL isVendor;
@property (nonatomic, assign) BOOL isHistory;

@end
