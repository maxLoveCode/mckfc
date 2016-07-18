//
//  DynamicHeightTextCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DynamicHeightTextCell.h"
#define itemHeight 44

@interface DynamicHeightTextCell ()

@end

@implementation DynamicHeightTextCell

-(instancetype)init
{
    self = [super init];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(UITextView *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UITextView alloc] init];
        _contentLabel.scrollEnabled = NO;
        [_contentLabel setFrame:CGRectMake(k_Margin, itemHeight-10, kScreen_Width-2*k_Margin, itemHeight)];
    }
    return _contentLabel;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, itemHeight)];
        _titleLabel.textColor = COLOR_WithHex(0x565656);
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
