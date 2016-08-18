//
//  InspectDetailView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "InspectDetailView.h"

@implementation InspectDetailView

-(instancetype)init
{
    self = [super init];
    return self;
}

-(UITableView *)detailView
{
    if (!_detailView) {
        _detailView = [[UITableView alloc] init];
    }
    return _detailView;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _confirm;
}

-(UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _cancel;
}

@end
