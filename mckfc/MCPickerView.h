//
//  MCPickerView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/24.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCPickerView;

@protocol MCPickerViewDelegate <NSObject>

-(void)pickerView:(MCPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface MCPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSArray* greaterOrderData;
@property (nonatomic, strong) NSArray* data;

@property (nonatomic, strong) UIPickerView* picker;
@property (nonatomic, strong) UIView* mask;

@property (nonatomic, weak) id <MCPickerViewDelegate> delegate;

@property (nonatomic, assign) NSIndexPath* index;
@property (nonatomic, copy) NSString* key;

-(instancetype)initWithArray:(NSArray*)data;
-(void)show;

@end
