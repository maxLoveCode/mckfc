//
//  LoadingCell.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/20.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "LoadingCell.h"

#define itemHeight 44
@interface LoadingCell()<UITextViewDelegate>

@end

@implementation LoadingCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadingStats"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

-(instancetype)initWithStyle:(LoadingCellStyle)style
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"loadingStats"];
    self.style = style;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftImageView];
    
    if (self.style == LoadingCellStyleSelection) {
        [self.contentView addSubview:self.detailLabel];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
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
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

-(UITextView *)textField
{
    if (!_textField) {
        _textField = [[UITextView alloc] init];
        _textField.textColor = COLOR_WithHex(0x565656);
        _textField.font = [UIFont systemFontOfSize:13];
        [_textField setReturnKeyType:UIReturnKeyDone];
    }
    return _textField;
}

-(UITextField *)digitInput
{
    if (!_digitInput) {
        _digitInput = [[UITextField alloc] init];
        _digitInput.textColor = COLOR_WithHex(0x565656);
        _digitInput.font = [UIFont systemFontOfSize:14];
        _digitInput.textAlignment = NSTextAlignmentRight;
        _digitInput.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _digitInput;
}

-(UITextField *)textInput
{
    if (!_textInput) {
        _textInput = [[UITextField alloc] init];
        _textInput.textColor = COLOR_TEXT_GRAY;
        _textInput.font = [UIFont systemFontOfSize:14];
    }
    return _textInput;
}

-(UIButton *)popUpBtn
{
    if (!_popUpBtn) {
        _popUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popUpBtn setTitle:@"填写省份" forState:UIControlStateNormal];
        [_popUpBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [_popUpBtn setTitleColor:COLOR_WithHex(0x565656) forState:UIControlStateSelected];
        _popUpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_popUpBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_popUpBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateSelected];
        _popUpBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _popUpBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _popUpBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        _popUpBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _popUpBtn;
}

-(void)setStyle:(LoadingCellStyle)style
{
    self->_style = style;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftImageView];
    if(style == LoadingCellStyleSelection ||
       style == LoadingCellStyleDatePicker){
        [self.contentView addSubview:self.detailLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (style == LoadingCellStyleBoolean){
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"uncheck"]];
        self.titleLabel.textColor = COLOR_TEXT_GRAY;
    }
    else if(style == LoadingCellStyleTextField){
        [self addSubview:self.textField];
    }
    else if(style == LoadingCellStyleDigitInput){
        [self addSubview:self.digitInput];
        UILabel* kg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        kg.textColor =COLOR_TEXT_GRAY;
        kg.font = [UIFont systemFontOfSize:14];
        kg.text = @"吨";
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = kg;
    }
    else if(style == LoadingCellStylePlain)
    {
        [self addSubview:self.detailLabel];
    }
    else if(style == LoadingCellStyleTextInput)
    {
        [self addSubview:self.textInput];
    }
    else if(style == LoadingCellStyleCarPlateInput)
    {
        [self addSubview:self.popUpBtn];
        [self addSubview:self.textInput];
    }
}

#pragma mark layouts
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageframe = CGRectMake(10, 0, itemHeight, itemHeight);
    [self.leftImageView setFrame:imageframe];
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(imageframe), 0, 90, itemHeight)];
    [self.detailLabel setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, kScreen_Width-CGRectGetMaxX(self.titleLabel.frame)-50, itemHeight)];
    if (self.style == LoadingCellStyleTextField) {
        [self.textField setFrame:CGRectMake(k_Margin, itemHeight-10, kScreen_Width-2*k_Margin, itemHeight)];
    }else if(self.style == LoadingCellStyleDigitInput){
        [self.digitInput setFrame:self.detailLabel.frame];
    }
    else if(self.style == LoadingCellStylePlain){
        [self.detailLabel setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, kScreen_Width-CGRectGetMaxX(self.titleLabel.frame)-k_Margin, itemHeight)];
    }
    else if(self.style == LoadingCellStyleTextInput)
    {
        [self.textInput setFrame:self.detailLabel.frame];
    }
    else if(self.style == LoadingCellStyleCarPlateInput)
    {
        CGFloat detailX = CGRectGetMaxX(_titleLabel.frame)+20;
        [self.textInput setFrame:
         CGRectMake(detailX+100, 0, kScreen_Width-detailX-90, itemHeight)];
        [self.popUpBtn setFrame:CGRectMake(detailX, 0, 90, itemHeight)];
    }
}


@end
