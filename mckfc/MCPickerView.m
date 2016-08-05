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

-(instancetype)init
{
    self = [super init];
    
    [self setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [self addSubview:self.mask];
    [self addSubview:self.picker];
    return self;
}

-(instancetype)initWithArray:(NSArray*)data
{
    self = [super init];
    self.data = data;
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
        _picker.userInteractionEnabled = YES;
        [_picker setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer* select = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelect)];
        [_picker addGestureRecognizer:select];
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

#pragma mark UIPickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(_greaterOrderData)
        return 2;
    else
        return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_greaterOrderData) {
        if (component == 0) {
            return [_greaterOrderData count];
        }
        else
            return [_data count];
    }
    else
        return [_data count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_greaterOrderData) {
        if (component == 0) {
            return [[_greaterOrderData objectAtIndex:row] description];
        }
        else
            return [[_data objectAtIndex:row] description];
    }
    else
        return [[_data objectAtIndex:row] description];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return itemHeight;
}

#pragma mark UIPickerview select delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate pickerView:self didSelectRow:row inComponent:component];
}

-(void)tapSelect
{
    [self.picker.delegate pickerView:self.picker didSelectRow:[_picker selectedRowInComponent:0] inComponent:0];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)dismiss
{
    [self removeFromSuperview];
}

-(void)setData:(NSArray *)data
{
    if (self.data) {
        self->_data = data;
        [self.picker reloadAllComponents];
    }
    else
    {
        self->_data = data;
    }
}

@end
