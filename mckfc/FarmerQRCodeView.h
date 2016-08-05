//
//  FarmerQRCodeView.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeView.h"

@interface FarmerQRCodeView : UIView

@property (nonatomic, strong) UIButton* screenShot;
@property (nonatomic, strong) UIButton* saveSheet;
@property (nonatomic, strong) QRCodeView* qrcode;

-(CGFloat)viewHeight;

@end
