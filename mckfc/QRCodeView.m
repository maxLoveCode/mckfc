//
//  QRCodeView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/21.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QRCodeView.h"
#import "GDQrCode.h"

@implementation QRCodeView

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(void)setQRCode:(NSString *)msg
{
    [self.imageView setFrame:CGRectMake(0, 0, 260, 260 )];
    
    [self.imageView gd_setQRCodeImageWithQRCodeImageSize:260
                                        qrCodeImageColor:[UIColor blackColor]
                                      qrCodeBgImageColor:[UIColor whiteColor]
                                             centerImage:nil
                                             codeMessage:msg];
}

@end
