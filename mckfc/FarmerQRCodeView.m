//
//  FarmerQRCodeView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//


#import "FarmerQRCodeView.h"
#import "QRCodeView.h"
#import "Masonry.h"

@interface FarmerQRCodeView ()

@property (nonatomic, strong) QRCodeView* qrcode;

@end

@implementation FarmerQRCodeView

-(instancetype)init
{
    self = [super init];
    [self addSubview:self.qrcode];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, CGRectGetMaxY(_qrcode.frame)));
    }];
    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.mas_equalTo(@0);
    }];
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

@end
