//
//  QRDetailController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QRDetailController.h"

@implementation QRDetailController

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.qrcode];
    
    UIView* superView = self.view;
    [self.qrcode makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(QRCodeSize, QRCodeSize));
        make.top.equalTo(superView).with.offset(@20);
        make.centerX.equalTo(superView);
    }];
}


-(QRCodeView *)qrcode
{
    if (!_qrcode) {
        _qrcode = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, QRCodeSize, QRCodeSize)];
    }
    return _qrcode;
}

-(void)setData:(NSDictionary *)data
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.qrcode setQRCode:jsonstring];
}
@end
