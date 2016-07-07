//
//  AlertHUDView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "AlertHUDView.h"
#import "AppDelegate.h"

#define width 286
#define height 200

#define titleHeight 40


@implementation AlertHUDView

-(instancetype)init
{
    self = [super init];
    [self layoutSubviews];
    return self;
}

-(instancetype)initWithStyle:(HUDAlertStyle )style
{
    self = [self init];
    self.style = style;
    
    if(_style == HUDAlertStyleNetworking)
    {
        [self.wrapperView addSubview:self.HUDimage];
    }
    
    return self;
}

-(UIView *)wrapperView
{
    if (!_wrapperView) {
        _wrapperView = [[UIView alloc] init];
        [_wrapperView addSubview:self.title];
        [_wrapperView addSubview:self.detail];
        
        
        _wrapperView.layer.cornerRadius = 4;
        _wrapperView.layer.masksToBounds = YES;
        [_wrapperView.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    }
    return _wrapperView;
}


-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        [_title setBackgroundColor:COLOR_THEME];
        _title.textColor = COLOR_THEME_CONTRAST;
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

-(UILabel *)detail
{
    if (!_detail) {
        _detail = [[UILabel alloc] init];
        [_detail setBackgroundColor:[UIColor whiteColor]];
        _detail.textAlignment = NSTextAlignmentCenter;
    }
    return _detail;
}


-(UIView *)mask
{
    if (!_mask) {
        _mask = [[UIView alloc] init];
        [_mask setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        _mask.userInteractionEnabled = NO;
    }
    return _mask;
}

-(UIImageView *)HUDimage
{
    if (!_HUDimage) {
        _HUDimage = [[UIImageView alloc] init];
        
        NSMutableArray* images = [[NSMutableArray alloc] init];
        for (int i=0; i<3; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gifloading_%i", i]]];
        }
        _HUDimage.animationDuration = 1;
        _HUDimage.animationImages = images;
    }
    return _HUDimage;
}

-(UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setBackgroundColor:COLOR_THEME];
        [_confirm setTitle:@"OK" forState:UIControlStateNormal];
        [_confirm setFrame:CGRectMake(0, CGRectGetMaxY(self.detail.frame), CGRectGetWidth(self.wrapperView.frame), titleHeight)];
        [_confirm setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        [_confirm addTarget:self action:@selector(HUDDidConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirm;
}

#pragma mark layouts
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.mask setFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [self.wrapperView setFrame:CGRectMake(0, 0, width, height)];
    [self.wrapperView setCenter:_mask.center];
    
    [self.title setFrame:CGRectMake(0, 0, width, titleHeight)];
    [self.detail setFrame:CGRectMake(0, titleHeight, width, height-titleHeight*2)];
    
    if(_style == HUDAlertStyleNetworking)
    {
        [self.HUDimage setFrame:CGRectMake(0, 0, height-titleHeight+60, height-titleHeight+60)];
        self.HUDimage.center = self.detail.center;
    }
    
    [self addSubview:self.mask];
}

-(void)show: (AlertHUDView*)alert 
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    
    [alert.mask addSubview:alert.wrapperView];
    [window addSubview:alert];
    [alert setFrame:window.bounds];

    if(_style == HUDAlertStyleNetworking)
    {
        self.title.text = @"网络加载中";
        [self.HUDimage startAnimating];
    }
    else
    {
        
        alert.mask.userInteractionEnabled = YES;
        [alert.wrapperView addSubview:alert.confirm];
    }
}

-(void)dismiss:(AlertHUDView *)alert
{
    [UIView animateWithDuration:1 animations:^{
        alert.alpha = 0.1;
    }completion:^(BOOL finished) {
        [alert.HUDimage stopAnimating];
        [alert removeFromSuperview];
    }];
}

-(void)failureWithMsg:(AlertHUDView *)alert msg:(NSString*)msg
{
    [alert.HUDimage stopAnimating];
    [alert.HUDimage removeFromSuperview];
    
    alert.detail.text = msg;
    [alert.wrapperView addSubview:alert.confirm];
    
    alert.mask.userInteractionEnabled = YES;
}

#pragma mark btn selector
-(void)HUDDidConfirm
{
    [self.delegate didSelectConfirm];
}


@end
