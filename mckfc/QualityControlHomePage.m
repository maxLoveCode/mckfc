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
#import "SettingViewController.h"
#import "ServerManager.h"

#import "LoginNav.h"
#import "TODOViewController.h"
#import "WorkDetailViewController.h"


#import "JPushService.h"

@interface QualityControlHomePage () <CommonUserViewDelegate,QRCodeReaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) CommonUserView* userView;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, copy) NSString* ScanedTransportID;

@end

@implementation QualityControlHomePage

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
    NSLog(@"appear");
    if (!_user) {
        [self requestUserInfo];
    }
}

-(void)requestUserInfo
{
    //根据 access token 判断第一次
    if (_server.accessToken) {
        NSDictionary* params = @{@"token": _server.accessToken};
        [_server GET:@"getUserInfo" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSError* error;
            NSDictionary* data = responseObject[@"data"];
            _user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            _userView.user = _user;
            [self setAliasForNotification:data[@"userid"]];
            
            if (_user.type != [MKUSER_TYPE_QUALITYCONTROL integerValue]
                && _user.type != [MKUSER_TYPE_UNLOAD integerValue]
                && _user.type != [MKUSER_TYPE_QUALITYCONTROL2 integerValue]) {
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
    
    [reader setCompletionWithBlock:^(NSString *resultAsString){
        NSLog(@"%@", resultAsString);
        [vc dismissViewControllerAnimated:YES completion:^{
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[resultAsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"token": _server.accessToken}];
            [params addEntriesFromDictionary:json];
            [_server POST:@"scanCommon" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                _ScanedTransportID = [params objectForKey:@"transportid"];
                
                //navigate to detail
                [self navigateToWorkDetail:_ScanedTransportID];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
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

@end
