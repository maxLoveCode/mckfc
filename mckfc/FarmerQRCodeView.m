//
//  FarmerQRCodeView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#define itemHeight 44

#import "FarmerQRCodeView.h"

@interface FarmerQRCodeView ()

@property (nonatomic, strong) UILabel* leftLabel;
@property (nonatomic, strong) UILabel* rightLabel;

@end

@implementation FarmerQRCodeView

-(instancetype)init
{
    self = [super init];
    [self addSubview:self.qrcode];
    [self addSubview:self.screenShot];
    [self addSubview:self.saveSheet];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    
    [self layout];
    
    return self;
}

-(QRCodeView *)qrcode
{
    if (!_qrcode) {
        _qrcode = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, QRCodeSize, QRCodeSize)];
        [_qrcode setQRCode:@"test"];
    }
    return _qrcode;
}

-(UIButton *)screenShot
{
    if (!_screenShot) {
        _screenShot = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_screenShot setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        _screenShot.layer.cornerRadius = itemHeight/2;
        _screenShot.layer.masksToBounds = YES;
        [_screenShot setImage:[UIImage imageNamed:@"saveQRcode"] forState:UIControlStateNormal];
    }
    return _screenShot;
}

-(UIButton *)saveSheet
{
    if (!_saveSheet) {
        _saveSheet = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_saveSheet setBackgroundColor:COLOR_WithHex(0x565656)];
        _saveSheet.layer.cornerRadius = itemHeight/2;
        [_saveSheet setImage:[UIImage imageNamed:@"saveSheet"] forState:UIControlStateNormal];
        _saveSheet.layer.masksToBounds = YES;
        
    }
    return _saveSheet;
}

-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"保存至手机";
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = COLOR_WithHex(0x565656);
        [_leftLabel sizeToFit];
    }
    return _leftLabel;
}

-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"录入运输单";
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = COLOR_WithHex(0x565656);
        [_rightLabel sizeToFit];
    }
    return _rightLabel;
}

-(void)layout
{
    int padding = 20;
    UIView* superView = self;
    [self.qrcode makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(QRCodeSize, QRCodeSize));
        make.top.equalTo(superView).with.offset(@20);
        make.centerX.equalTo(superView);
        make.bottom.equalTo(self.screenShot.top).with.offset(-padding);
    }];
    [self.screenShot makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(itemHeight, itemHeight));
        make.top.equalTo(self.qrcode.bottom).with.offset(padding);
        make.left.greaterThanOrEqualTo(self.qrcode.left);
    }];
    [self.saveSheet makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(itemHeight, itemHeight));
        make.top.equalTo(self.qrcode.bottom).with.offset(padding);
        make.right.greaterThanOrEqualTo(self.qrcode.right);
    }];
    [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenShot.bottom).with.offset(5);
        make.centerX.equalTo(self.screenShot);
    }];
    [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenShot.bottom).with.offset(5);
        make.centerX.equalTo(self.saveSheet);
    }];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreen_Width);
        make.bottom.equalTo(self.leftLabel.bottom);
    }];
}

-(CGFloat)viewHeight
{
    return CGRectGetHeight(self.frame);
}


@end
