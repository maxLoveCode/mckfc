//
//  orderGeneralReport.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/9.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "orderGeneralReport.h"
#define itemHeight 44

@implementation orderGeneralReport

-(instancetype)init
{
    self = [super init];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.detailLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

#pragma mark property setter
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WithHex(0x565656);
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = COLOR_WithHex(0x565656);
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

-(UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_avatar"]];
    }
    return _leftImageView;
}

#pragma mark layouts
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageframe = CGRectMake(10, 0, itemHeight, itemHeight);
    [self.leftImageView setFrame:imageframe];
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(imageframe), 0, 100, itemHeight)];
    [self.detailLabel setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, CGRectGetWidth(self.contentView.frame)-CGRectGetMaxX(self.titleLabel.frame)-k_Margin, itemHeight)];
    
}
@end
