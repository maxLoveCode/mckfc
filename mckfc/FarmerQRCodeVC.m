//
//  FarmerQRCodeVC.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/4.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "FarmerQRCodeVC.h"
#import "FarmerQRCodeView.h"

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

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
    UIApplication* application = [UIApplication sharedApplication];
    UIWindow* window = application.keyWindow;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * imgData = UIImagePNGRepresentation(image);
    
    //animation
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [application.keyWindow addSubview:whiteView];
    AudioServicesPlaySystemSound(1108);
    [UIView animateWithDuration: 0.5
                     animations: ^{
                         whiteView.alpha = 0.0;
                     }
                     completion: ^(BOOL finished) {
                         [whiteView removeFromSuperview];
                     }
     ];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    if(imgData)
        [imgData writeToFile:@"screenshot.png" atomically:YES];
    else
        NSLog(@"error while taking screenshot");
    
}

-(void)saveSheet:(id)sender
{
    NSLog(@"saveSheet");
}



@end
