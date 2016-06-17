//
//  AlertHUDView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "AlertHUDView.h"

#define width 240
#define height 167

@implementation AlertHUDView

-(instancetype)init
{
    self = [super init];
    
    return self;
}

-(UIView *)wrapperView
{
    if (!_wrapperView) {
        _wrapperView = [[UIView alloc] init];
        [_wrapperView addSubview:self.title];
        [_wrapperView addSubview:self.detail];
    }
    return _wrapperView;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
    }
    return _title;
}

-(UILabel *)detail
{
    if (!_detail) {
        _detail = [[UILabel alloc] init];
    }
    return _detail;
}

-(UIView *)mask
{
    if (!_mask) {
        _mask = [[UIView alloc] init];
    }
    return _mask;
}

-(void)layoutSubviews
{
    [_wrapperView setFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    _wrapperView
}


@end
