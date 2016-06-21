//
//  DriverDetailEditorCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DriverDetailEditorCell.h"

#define itemHeight 44

@interface DriverDetailEditorCell ()

@end

@implementation DriverDetailEditorCell

-(instancetype)initWithStyle:(DriverDetailCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    self.style = style;
    
    
    [self.contentView addSubview:self.titleLabel];
    if (self.style == DriverDetailCellStylePlain) {
        [self.contentView addSubview:self.detailLabel];
    }
    else if (self.style == DriverDetailCellStyleAvatar){
        [self.contentView addSubview:self.avatar];
    }
    else if (self.style == DriverDetailCellStyleCarNumber){
        [self.contentView addSubview:self.detailLabel];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

-(UITextField *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UITextField alloc] init];
        _detailLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _detailLabel;
}

-(UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
    }
    return _avatar;
}

#pragma mark layouts
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel setFrame:CGRectMake(k_Margin, 0 ,100, itemHeight)];
    CGFloat detailX = CGRectGetMaxX(_titleLabel.frame)+20;
    if (self.style == DriverDetailCellStylePlain) {
        [self.detailLabel setFrame:
            CGRectMake(detailX, 0, kScreen_Width-detailX, itemHeight)];
    }
    else if (self.style == DriverDetailCellStyleAvatar){
        [self.avatar setFrame:CGRectMake(detailX, 2, 40, 40)];
    }
    else if (self.style == DriverDetailCellStyleCarNumber){
        [self.detailLabel setFrame:
         CGRectMake(detailX+100, 0, kScreen_Width-detailX-100, itemHeight)];
    }
}

#pragma mark return cell height
+(CGFloat)heightForCell
{
    return itemHeight;
}
@end
