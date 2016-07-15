//
//  WorkRecordCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/8.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "WorkRecordCell.h"
#import "WorkStatusView.h"

#define orderLabelHeight 44
#define mainLabelHeight 66
#define statusHeight 44

extern NSString *const reuseIdentifier;

@interface WorkRecordCell ()
{
    UIView* colorIndex;
}

@property (nonatomic, strong) UILabel* orderLabel;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* carLabel;
@property (nonatomic, strong) UILabel* warehouse;
@property (nonatomic, strong) WorkStatusView* statusView;

@end

@implementation WorkRecordCell

-(instancetype)init
{
    NSString *const reuseIdentifier = @"workRecord";
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    for (UIView* subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    [self.contentView addSubview:self.orderLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.carLabel];
    [self.contentView addSubview:self.warehouse];
    
    [self.contentView addSubview:self.statusView];
    
    colorIndex = [[UIView alloc] init];
    [colorIndex setBackgroundColor:COLOR_THEME];
    [self.contentView addSubview:colorIndex];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return self;
}

#pragma mark setters
-(UILabel *)orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.text = @"订单编号：";
        _orderLabel.font = [UIFont systemFontOfSize:13];
        _orderLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _orderLabel;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"司机名字";
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = COLOR_WithHex(0x565656);
    }
    return _nameLabel;
}

-(UILabel *)carLabel
{
    if (!_carLabel) {
        _carLabel = [[UILabel alloc] init];
        _carLabel.text = @"黑 A42356";
        _carLabel.font = [UIFont systemFontOfSize:14];
        _carLabel.textColor = COLOR_WithHex(0x565656);
    }
    return _carLabel;
}

-(UILabel *)warehouse
{
    if (!_warehouse) {
        _warehouse = [[UILabel alloc] init];
        _warehouse.text = @"AC462库";
        _warehouse.textColor = COLOR_TEXT_GRAY;
        _warehouse.font = [UIFont systemFontOfSize:14];
    }
    return _warehouse;
}

-(WorkStatusView *)statusView
{
    if (!_statusView) {
        _statusView = [[WorkStatusView alloc] init];
    }
    return _statusView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.orderLabel setFrame:CGRectMake(k_Margin, 0, kScreen_Width-2*k_Margin, orderLabelHeight)];
    [self.nameLabel setFrame:CGRectMake(k_Margin, CGRectGetMaxY(self.orderLabel.frame), mainLabelHeight+30, mainLabelHeight)];
    [self.carLabel setFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMinY(self.nameLabel.frame), 140, CGRectGetHeight(self.nameLabel.frame))];
    [self.warehouse setFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame)-60, CGRectGetMaxY(self.orderLabel.frame), 60, mainLabelHeight)];
    [self.statusView setFrame:CGRectMake(k_Margin, CGRectGetMaxY(self.nameLabel.frame), kScreen_Width - 2*k_Margin, statusHeight)];
    
    UIView* topMargin = [[UIView alloc] init];
    [topMargin setFrame:CGRectMake(CGRectGetMinX(self.orderLabel.frame), CGRectGetMaxY(self.orderLabel.frame), kScreen_Width-2*k_Margin, 1)];
    UIView* botMargin = [[UIView alloc] init];
    [botMargin setFrame:CGRectOffset(topMargin.frame, 0, mainLabelHeight)];
    [topMargin setBackgroundColor:COLOR_WithHex(0xdddddd)];
    [botMargin setBackgroundColor:COLOR_WithHex(0xdddddd)];
    
    [colorIndex setFrame:CGRectMake(0, 13.5, 11, 17)];
    
    [self.contentView addSubview:topMargin];
    [self.contentView addSubview:botMargin];
}

-(void)setRecord:(workRecord *)record
{
    self->_record = record;
    self.orderLabel.text = [NSString stringWithFormat:@"订单编号：%@", record.transportno];
    if ([record.driver isEqualToString:@""]) {
        self.nameLabel.text = @"未命名司机";
    }
    else
    {
        self.nameLabel.text = record.driver;
    }
    self.carLabel.text = record.truckno;
    self.warehouse.text = record.storename;
    [self.statusView setData:record.reportArray];
}

+(CGFloat)HeightForWorkRecordCell
{
    return 154.0f;
}

@end
