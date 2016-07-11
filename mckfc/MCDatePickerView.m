//
//  MCDatePickerView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "MCDatePickerView.h"

@implementation MCDatePickerView

-(instancetype)init
{
    self = [super init];
    [self setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [self addSubview:self.mask];
    [self addSubview:self.picker];
    return self;
}

-(UIDatePicker *)picker
{
    if (!_picker) {
        _picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreen_Height-200, kScreen_Width, 200)];
        [_picker setBackgroundColor:[UIColor whiteColor]];
        [_picker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        [_picker setFrame:CGRectMake(0, kScreen_Height-250, kScreen_Width, 250)];
        _picker.userInteractionEnabled = YES;
    }
    return _picker;
}

-(UIView *)mask
{
    if (!_mask) {
        _mask = [[UIView alloc] initWithFrame:self.frame];
        [_mask setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_mask addGestureRecognizer:tap];
    }
    return _mask;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    [self.delegate datePickerViewDidSelectDate:datePicker.date];
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)dismiss
{
    [self removeFromSuperview];
}

@end
