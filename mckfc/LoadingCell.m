//
//  LoadingCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoadingCell.h"

#define itemHeight 44

@implementation LoadingCell

-(instancetype)initWithStyle:(LoadingCellStyle)style
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"loadingStats"];
    self.style = style;
    return self;
}

#pragma mark setter
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor darkTextColor];
    }
    return _titleLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _detailLabel;
}

-(UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

#pragma mark layouts
-(void)layoutSubviews
{
    CGRect imageframe = CGRectMake(k_Margin, 0, itemHeight, itemHeight);
    
}


@end
