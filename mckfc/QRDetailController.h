//
//  QRDetailController.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/17.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeView.h"

@interface QRDetailController : UIViewController

@property (nonatomic, strong) QRCodeView* qrcode;

-(void)setData:(NSDictionary*)data;

@end
