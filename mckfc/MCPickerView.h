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



@end

@interface MCPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSArray* data;

@property (nonatomic, strong) UIPickerView* picker;
@property (nonatomic, strong) UIView* mask;

@property (nonatomic, weak) id <MCPickerViewDelegate> delegate;


-(instancetype)initWithArray:(NSArray*)data;
-(void)show;

@end
