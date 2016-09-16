//
//  TruckArrivePicker.m
//  mckfc
//
//  Created by 华印mac-001 on 16/9/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TruckArrivePicker.h"

@interface TruckArrivePicker()

@property (nonatomic, strong) UIView* pickerWrapper;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIDatePicker* ymd;
@property (nonatomic, strong) UIButton* confirmed;
@property (nonatomic, strong) NSDate* date;

@end

@implementation TruckArrivePicker

-(instancetype)init
{
    self = [super init];
    [self setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    
    [self addSubview:self.pickerWrapper];
    [self.pickerWrapper addSubview:self.titleLabel];
    [self.pickerWrapper addSubview:self.ymd];
    [self.pickerWrapper addSubview:self.confirmed];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self addGestureRecognizer:tap];
    self.date = [NSDate date];
    return self;
}

-(UIView *)pickerWrapper
{
    if (!_pickerWrapper) {
        _pickerWrapper = [[UIView alloc] init];
        [_pickerWrapper setBackgroundColor:[UIColor whiteColor]];
        _pickerWrapper.layer.cornerRadius = 3;
        _pickerWrapper.layer.masksToBounds = YES;
    }
    return _pickerWrapper;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
        _titleLabel.text = @"请选择入场时间:";
        _titleLabel.textColor = COLOR_WithHex(0x565656);
    }
    return _titleLabel;
}

-(UIDatePicker *)ymd
{
    if (!_ymd) {
        _ymd = [[UIDatePicker alloc] init];
        //_ymd.date = self.date;
        
        [_ymd addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _ymd;
}

-(UIButton *)confirmed
{
    if (!_confirmed) {
        _confirmed = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmed setTitle:@"确    认" forState:UIControlStateNormal];
        [_confirmed setBackgroundColor:COLOR_THEME];
        [_confirmed setTitleColor:COLOR_THEME_CONTRAST forState:UIControlStateNormal];
        
        _confirmed.layer.cornerRadius = 3;
        _confirmed.layer.masksToBounds = YES;
        [_confirmed addTarget:self action:@selector(comfirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmed;
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints
{
    UIWindow* superView = [UIApplication sharedApplication].keyWindow;
    [self makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo(superView);
        make.size.equalTo(superView);
        make.left.equalTo(superView);
        make.right.equalTo(superView);
    }];
    
    [self.pickerWrapper makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreen_Width-2*k_Margin, 250));
        make.centerX.equalTo(superView.centerX);
        make.centerY.equalTo(superView.centerY);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.pickerWrapper).with.offset(-2*k_Margin);
        make.height.equalTo(@25);
        make.left.equalTo(self.pickerWrapper).with.offset(k_Margin);
        make.top.equalTo(self.pickerWrapper).with.offset(10);
    }];
    
    [self.ymd makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.titleLabel);
        make.height.equalTo(@140);
        make.top.equalTo(self.titleLabel.bottom).with.offset(@10);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.confirmed makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.titleLabel);
        make.top.equalTo(self.ymd.bottom).with.offset(10);
        make.bottom.equalTo(self.pickerWrapper.bottom).with.offset(-10);
        make.left.equalTo(self.titleLabel);
    }];
    
    [super updateConstraints];
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;
}

-(void)comfirm:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(_ymd.date);
        [self removeFromSuperview];
    }
}

-(void)dismiss:(id)sender
{
    [self removeFromSuperview];
}

@end
