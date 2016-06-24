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
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftImageView];
    
    if (self.style == LoadingCellStyleSelection) {
        [self.contentView addSubview:self.detailLabel];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

#pragma mark property setter
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_TEXT_GRAY;
        _titleLabel.font = [UIFont systemFontOfSize:13];
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
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    }
    return _leftImageView;
}

#pragma mark layouts
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageframe = CGRectMake(k_Margin, 0, itemHeight, itemHeight);
    [self.leftImageView setFrame:imageframe];
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(imageframe), 0, 100, itemHeight)];
    [self.detailLabel setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, kScreen_Width-CGRectGetMaxX(self.titleLabel.frame)-50, itemHeight)];
}


@end
