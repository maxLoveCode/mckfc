//
//  InspectDetailView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDetail.h"
#import "orderGeneralReport.h"
#import "WorkStatusView.h"

@interface InspectDetailView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* titleArray;
}

@property (nonatomic, strong) UITableView* detailView;
@property (nonatomic, strong) UIButton* confirm;
@property (nonatomic, strong) UIButton* cancel;
@property (nonatomic, strong) WorkStatusView* status;

@property (nonatomic,strong) WorkDetail* detail;

@end
