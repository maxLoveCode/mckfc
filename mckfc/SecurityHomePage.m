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
#import "AlertHUDView.h"
#import "SettingViewController.h"

#import "WorkRecordViewController.h"
#import "QRCodeReaderViewController.h"
#import "LoginNav.h"

#import "ServerManager.h"

#import "TODOViewController.h"
#import "WorkDetailViewController.h"

#import "JPushService.h"
#import "InspectDetailView.h"
#import "TruckArrivePicker.h"

@interface SecurityHomePage ()<CommonUserViewDelegate, QRCodeReaderDelegate, HUDViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) CommonUserView* userView;
@property (nonatomic, strong) ServerManager* server;

@property (nonatomic, strong) AlertHUDView* alert;
@property (nonatomic, strong) InspectDetailView* inspectView;
@property (nonatomic, copy) NSString* ScanedTransportID;

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
            
            [self setAliasForNotification:data[@"userid"]];
            
            if (_user.type != [MKUSER_TYPE_SECURITY integerValue]) {
                LoginNav* loginVC = [[LoginNav alloc] init];
                [self presentViewController:loginVC animated:NO completion:^{
                }];
            }
            else
            {
                [_userView.mainTableView reloadData];
            }
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
        [vc dismissViewControllerAnimated:YES completion:^{
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
    }];
}

-(void)navigateToTODO
{
    TODOViewController* todoVC = [[TODOViewController alloc] init];
    [self.navigationController pushViewController:todoVC animated:YES];
}

-(void)navigateToSetting
{
    SettingViewController* setting = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark tap avatar delegate
-(void)didTapAvatar
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *UIAlertAction){
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *UIAlertAction){
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark pick image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_server upLoadImageData:img forSize:CGSizeMake(100, 100) success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSString* url = responseObject[@"data"];
            [_server POST:@"updateUserInfo" parameters:@{@"token":_server.accessToken,
                                                         @"avatar":url} animated:NO
                  success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject){
                      
                      [self.user setAvatar:url];
                      self.userView.user = self.user;
                      
                      [self.userView.mainTableView reloadData];
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      
                  }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -alertview delegate
-(void)didSelectConfirm
{
    [self.alert removeFromSuperview];
    [self inspectArrivedTruck];
}

- (void)scanDataToServer:(NSDictionary*)data request:(NSString* )request success:(void(^)())success
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"token": _server.accessToken}];
    [params addEntriesFromDictionary:data];
    [_server POST:@"scanCommon" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _ScanedTransportID = [params objectForKey:@"transportid"];
        if([request isEqualToString:@"scanArrive"])
        {
            [self requestTruckDetail:_ScanedTransportID success:^{
                
            }];
        }
        else
        {
            //navigate to detail
            [self navigateToWorkDetail:_ScanedTransportID];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark- 车辆到厂
- (void)inspectArrivedTruck
{
    TruckArrivePicker* picker = [[TruckArrivePicker alloc] init];
    [picker show];
    [picker setSelectBlock:^(NSDate *result) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* dateString = [formater stringFromDate:result];
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"token": _server.accessToken,
                               @"transportid":_ScanedTransportID}];
        if (dateString != nil && ![dateString isEqualToString:@""]) {
            [params addEntriesFromDictionary:@{@"arrivetime":dateString}];
        }
        
        NSLog(@"%@", params);
        [_server POST:@"truckArrive" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            if(_inspectView)
            {
                [_inspectView removeFromSuperview];
            }
            //navigate to detail
                [self navigateToWorkDetail:_ScanedTransportID];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
        }];
    }];

}

-(void)navigateToWorkDetail:(NSString*)transportid
{
    WorkDetailViewController* detail = [[WorkDetailViewController alloc] init];
    [detail setTransportid: transportid];
    [self.navigationController pushViewController:detail animated:YES];
}


-(void)setAliasForNotification:(NSString*)alias
{
    NSString* aliasString = [NSString stringWithFormat:@"%@", alias];
    [JPUSHService setTags:nil alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
    }];
}

-(void)requestTruckDetail:(NSString*)transid success:(void(^)(void))success
{
    NSDictionary* params = @{@"token":_server.accessToken,
                             @"transportid":transid};
    
    [_server GET:@"getOrderDetail" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary* data = responseObject[@"data"];
        
        NSLog(@"response%@", data);
        [self popupDetails:data];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

-(void)popupDetails:(NSDictionary*)data
{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    _inspectView =[[InspectDetailView alloc] init];
    [keyWindow addSubview: _inspectView];
    [_inspectView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(keyWindow);
        make.edges.equalTo(keyWindow);
    }];
    
    NSError* error;
    WorkDetail* detail = [MTLJSONAdapter modelOfClass:[WorkDetail class] fromJSONDictionary:data error:&error];
    if (error) {
        NSLog(@"%@",error);
    }

    [_inspectView setDetail:detail];
    [_inspectView.confirm addTarget:self action:@selector(inspectArrivedTruck) forControlEvents:UIControlEventTouchUpInside];
}


@end
