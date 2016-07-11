//
//  TransportationViewCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/21.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "TransportationViewCell.h"

#define itemHeight 44

@implementation TransportationViewCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"plan"];
        
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

#pragma mark property setter
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_TEXT_GRAY;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = COLOR_WithHex(0x565656);
    }
    return _detailLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel setFrame:CGRectMake(k_Margin, 0 ,100, itemHeight)];
    CGFloat detailX = CGRectGetMaxX(_titleLabel.frame)+20;
    [self.detailLabel setFrame:
     CGRectMake(detailX, 0, kScreen_Width-detailX, itemHeight)];
}
@end
