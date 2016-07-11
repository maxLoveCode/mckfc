//
//  MCDatePickerView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/7/11.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCDatePickerView;

@protocol DatePickerDelegate <NSObject>

-(void)datePickerViewDidSelectDate:(NSDate*)date;

@end

@interface MCDatePickerView : UIView

@property (nonatomic, strong) UIDatePicker* picker;
@property (nonatomic, strong) UIView* mask;
@property (nonatomic, weak) id<DatePickerDelegate> delegate;


-(void)show;

@end
