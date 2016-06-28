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
    LoadingCellStyleSelection,
    LoadingCellStyleTextField,
    LoadingCellStyleImagePicker,
};

@interface LoadingCell : UITableViewCell

@property (nonatomic, strong) UIImageView* leftImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* detailLabel;

@property (nonatomic, assign) LoadingCellStyle style;

-(instancetype)init;
-(instancetype)initWithStyle:(LoadingCellStyle)style;

@end
