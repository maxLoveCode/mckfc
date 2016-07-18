//
//  rejectionSelectableCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/18.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "rejectionSelectableCell.h"
#define itemHeight 44

@implementation rejectionSelectableCell
-(instancetype)init
{
    self = [super init];
    
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"uncheck"]];
    return self;
}


#pragma mark property setter
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WithHex(0x565656);
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [_titleLabel setFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame), 0, 90, itemHeight)];
    }
    return _titleLabel;
}

-(UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayRejection"]];
        [_leftImageView setFrame:CGRectMake(10, 0, itemHeight, itemHeight)];
    }
    return _leftImageView;
}

@end
