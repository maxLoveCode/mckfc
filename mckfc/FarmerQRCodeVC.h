//
//  FarmerQRCodeVC.h
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FarmerQRCodeVC;

@protocol FarmerQRCodeVCDelegate <NSObject>

-(void)QRCodeViewDidSelectRecord:(FarmerQRCodeVC*)vc;

@end

@interface FarmerQRCodeVC : UIViewController

@property (nonatomic, weak) id<FarmerQRCodeVCDelegate> delegate;
-(void)setQRData:(NSString*)data;

@end
