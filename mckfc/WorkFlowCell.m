//
//  WorkFlowCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/9.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkFlowCell.h"
#define indicatorWidth 16

@implementation WorkFlowCell

-(instancetype)init
{
    self = [super init];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.indicator];
    [self.contentView addSubview:self.timeLabel];
    
    return self;
}

#pragma mark setters
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WithHex(0x565656);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _titleLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = COLOR_TEXT_GRAY;
        _detailLabel.text = @"读取车辆的运输状况中";
    }
    return _detailLabel;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = COLOR_TEXT_GRAY;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.text = @"yy-dd   hh:mm";
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

-(UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uncheck"]];
    }
    return _indicator;
}

#pragma mark layouts
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.indicator setFrame:CGRectMake(k_Margin, 9, indicatorWidth, indicatorWidth)];
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(self.indicator.frame)+k_Margin/2, 0, 30, [WorkFlowCell cellHeight]/2)];
    [self.detailLabel setFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), [WorkFlowCell cellHeight]/2, kScreen_Width-2*CGRectGetMinX(_titleLabel.frame), [WorkFlowCell cellHeight]/2)];
    [self.timeLabel setFrame:CGRectMake(kScreen_Width - 150-k_Margin, CGRectGetMinY(self.titleLabel.frame), 150, [WorkFlowCell cellHeight]/2)];
}

#pragma mark height
+(CGFloat)cellHeight
{
    return 66;
}

@end
