//
//  QualityControlHomePage.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "QualityControlHomePage.h"
#import "CommonUserView.h"
#import "CommonMenuView.h"
#import "WorkRecordViewController.h"
#import "QRCodeReaderViewController.h"

@interface QualityControlHomePage () <CommonUserViewDelegate, QRCodeReaderDelegate>

@property (nonatomic, strong) CommonUserView* userView;

@end

@implementation QualityControlHomePage

-(void)viewDidLoad
{
    _userView = [[CommonUserView alloc] init];
    _userView.delegate = self;
    self.view = _userView;
}

-(void)navigateToWorkRecord
{
    WorkRecordViewController *WRVC = [[WorkRecordViewController alloc] init];
    [self.navigationController pushViewController:WRVC animated:YES];
}

-(void)navigateToQRScanner
{
    // Create the reader object
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"取消" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:NO];
    
    // Set the presentation style
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    // Define the delegate receiver
    vc.delegate = self;
    
//    // Or use blocks
//    [reader setCompletionWithBlock:^(NSString *resultAsString) {
//        NSLog(@"%@", resultAsString);
//    }];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
