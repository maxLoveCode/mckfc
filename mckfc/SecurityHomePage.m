//
//  SecurityHomePage.m
//  mckfc
//
//  Created by 华印mac-001 on 16/7/7.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "SecurityHomePage.h"
#import "CommonUserView.h"
#import "CommonMenuView.h"
#import "WorkRecordViewController.h"
#import "QRCodeReaderViewController.h"

#import "User.h"
#import "ServerManager.h"

#import "AlertHUDView.h"

@interface SecurityHomePage ()<CommonUserViewDelegate, QRCodeReaderDelegate, HUDViewDelegate>

@property (nonatomic, strong) CommonUserView* userView;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) User* user;

@property (nonatomic, strong) AlertHUDView* alert;

@end

@implementation SecurityHomePage

-(void)viewDidLoad
{
    _userView = [[CommonUserView alloc] init];
    _userView.delegate = self;
    
    _server = [ServerManager sharedInstance];
    
    self.view = _userView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_user) {
        [self requestUserInfo];
    }
}

-(AlertHUDView *)alert
{
    if (!_alert) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStyleBool];
        _alert.delegate = self;
    }
    return _alert;
}

-(void)requestUserInfo
{
    //根据 access token 判断第一次
    if (_server.accessToken) {
        NSDictionary* params = @{@"token": _server.accessToken};
        [_server GET:@"getUserInfo" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSError* error;
            NSDictionary* data = responseObject[@"data"];
            _user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            _userView.user = _user;
            [_userView.mainTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    else{
        
    }
}


-(void)navigateToWorkRecord
{
    WorkRecordViewController *WRVC = [[WorkRecordViewController alloc] init];
    [self.navigationController pushViewController:WRVC animated:YES];
}

-(void)navigateToQRScannerWithItem:(NSInteger)item
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
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"result :%@", resultAsString);
        [vc dismissViewControllerAnimated:YES completion:NULL];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[resultAsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        if (item == 0) {
            [self scanDataToServer:json request:@"scanArrive" success:^{
                
            }];
        }
        else{
            [self scanDataToServer:json request:@"scanCommon" success:^{
                
            }];
        }
    }];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)didTapAvatar
{
    
}

- (void)scanDataToServer:(NSDictionary*)data request:(NSString* )request success:(void(^)())success
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"token": _server.accessToken}];
    [params addEntriesFromDictionary:data];
    NSLog(@"params%@", params);
    [_server POST:request parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"response: %@",responseObject);
        self.alert.title.text = @"确认车辆到厂";
        self.alert.detail.text = [responseObject[@"data"] objectForKey:@"message"];
        [self.alert show:_alert];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)didSelectConfirm
{
    [self.alert removeFromSuperview];
}



@end
