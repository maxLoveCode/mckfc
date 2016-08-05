//
//  FarmerQRCodeVC.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "FarmerQRCodeVC.h"
#import "FarmerQRCodeView.h"

@interface FarmerQRCodeVC ()

@property (strong, nonatomic) FarmerQRCodeView* QRView;

@end

@implementation FarmerQRCodeVC

-(void)viewDidLoad
{
    self.view = self.QRView;
}

-(FarmerQRCodeView *)QRView
{
    if (!_QRView) {
        _QRView = [[FarmerQRCodeView alloc] init];
        //[_QRView setFrame:CGRectMake(0, 0, kScreen_Width, 400)];
        [_QRView.screenShot addTarget:self action:@selector(screenShot:) forControlEvents:UIControlEventTouchUpInside];
        [_QRView.saveSheet addTarget:self action:@selector(saveSheet:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QRView;
}

-(void)screenShot:(id)sender
{
    NSLog(@"screenShot");
}

-(void)saveSheet:(id)sender
{
    NSLog(@"saveSheet");
}



@end
