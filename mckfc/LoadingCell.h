//
//  LoadingCell.h
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadingCell;

typedef NS_ENUM(NSUInteger, LoadingCellStyle) {
    LoadingCellStylePlain,  //一个 title 一个 detail
    LoadingCellStyleSelection, //点击出现选择器
    LoadingCellStyleTextField, //点击出现 textfield， 两倍高度
    LoadingCellStyleImagePicker, //点击上传图片，暂时不需要了
    LoadingCellStyleDigitInput, //填写重要，accessoryview 是 KG
    LoadingCellStyleBoolean, //左边是一个点击切换布尔值的 cell，现在也不需要了
    LoadingCellStyleDatePicker //需求又改了，现在要专门选择年月日
};

@interface LoadingCell : UITableViewCell

@property (nonatomic, strong) UIImageView* leftImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* detailLabel;

@property (nonatomic, strong) UITextView* textField;
@property (nonatomic, strong) UITextField* digitInput;

@property (nonatomic, assign) LoadingCellStyle style;

-(instancetype)init;
-(instancetype)initWithStyle:(LoadingCellStyle)style;

@end
