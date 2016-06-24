//
//  MCPickerView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/24.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "MCPickerView.h"

#define itemHeight 44;

@implementation MCPickerView

-(instancetype)initWithArray:(NSArray*)data
{
    self = [super init];
    self.data = data;
    [self setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [self.mask addSubview:self.picker];
    [self addSubview:self.mask];
    return self;
}

#pragma mark setters
-(UIPickerView *)picker
{
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.dataSource = self;
        _picker.delegate = self;
        [_picker setFrame:CGRectMake(0, kScreen_Height-200, kScreen_Width, 200)];
        [_picker setBackgroundColor:COLOR_THEME];
    }
    return _picker;
}

-(UIView *)mask
{
    if (!_mask) {
        _mask = [[UIView alloc] initWithFrame:self.frame];
        [_mask setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        _mask.userInteractionEnabled = NO;
    }
    return _mask;
}

#pragma mark UIPickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_data count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_data objectAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return itemHeight;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
