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
    NSLog(@"set QRCode");
    [self.imageView setFrame:CGRectMake(0, 0, 288, 288 )];
    
    [self.imageView gd_setQRCodeImageWithQRCodeImageSize:288
                                        qrCodeImageColor:[UIColor blackColor]
                                      qrCodeBgImageColor:[UIColor whiteColor]
                                             centerImage:[UIImage imageNamed:@"star"]
                                             codeMessage:@"test"];
}

@end
