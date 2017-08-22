//
//  MakeConcessionsViewController.h
//  mckfc
//
//  Created by 华印mac－002 on 2017/8/1.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InspectionReport.h"
@interface MakeConcessionsViewController : UIViewController
@property (nonatomic, assign) NSString* transportid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *mainType;
@property (nonatomic, strong) InspectionReport* insepection;
@end
