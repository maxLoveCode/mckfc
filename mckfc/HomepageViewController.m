//
//  HomepageViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "HomepageViewController.h"
#import "UserView.h"
#import "ServerManager.h"
#import "LoginNav.h"
#import "LoadingStatsViewController.h"
#import "DriverDetailEditorController.h"

#import "TranspotationPlanViewController.h"
#import "QueueViewController.h"
#import "MsgListViewController.h"

#import "EditorNav.h"

#import "JPushService.h"

#import "rightNavigationItem.h"
#import "QRCodeReaderViewController.h"

#import "LoadingStats.h"

@interface HomepageViewController ()<UserViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,menuDelegate,QRCodeReaderDelegate>

@property (nonatomic, strong) UserView* userview;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) rightNavigationItem* popUpMenu;
@property (nonatomic, strong) LoadingStats* stats;

@end

@implementation HomepageViewController

-(void)viewDidLoad
{
    self.title = @"首页";
    _userview = [[UserView alloc] init];
    _server = [ServerManager sharedInstance];
    
    _userview.delegate = self;
    
    self.navigationItem.rightBarButtonItem = self.popUpMenu;
    self.view = _userview;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_user) {
        [self requestUserInfo];
    }
}

-(rightNavigationItem *)popUpMenu
{
    if (!_popUpMenu) {
        _popUpMenu = [[rightNavigationItem alloc] initCutomItem];
        _popUpMenu.ItemStyle = navItemStyleHomepage;
        _popUpMenu.delegate =self;
    }
    return _popUpMenu;
}

-(void)requestUserInfo
{
    //根据 access token 判断第一次
    if (_server.accessToken) {
        NSDictionary* params = @{@"token": _server.accessToken};
        [_server GET:@"getUserInfo" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"] integerValue] == 10003) {
                [self navigateToEditor];
                return;
            }
            
            NSError* error;
            NSDictionary* data = responseObject[@"data"];
            _user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            [_userview setContentByUser:_user];
    
            [self checkIfNeedsToUpdateUser];
            [self checkIfNeedsToContinue];
            [self setAliasForNotification:data[@"userid"]];
            
            if (_user.type != [MKUSER_TYPE_DRIVER integerValue]) {
                LoginNav* loginVC = [[LoginNav alloc] init];
                [self presentViewController:loginVC animated:NO completion:^{
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    else{
        LoginNav* loginVC = [[LoginNav alloc] init];
        [self presentViewController:loginVC animated:NO completion:^{
            }];
    }
}

#pragma mark select loading selector
-(void)didClickConfirm
{
    LoadingStatsViewController *loadingStats = [[LoadingStatsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:loadingStats animated:YES];
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
                          [self.userview setContentByUser:self.user];
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                      }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark navigations
-(void)checkIfNeedsToUpdateUser
{
    if(![_user validation]){
      
    }
}

-(void)navigateToEditor
{
    EditorNav* editVC = [[EditorNav alloc] init];
    DriverDetailEditorController* driverVC =(DriverDetailEditorController*)editVC.topViewController;
    [driverVC setUser:_user];
    [driverVC setRegisterComplete:NO];
    [self.navigationController presentViewController:editVC animated:YES completion:^{
        
    }];
    [editVC setOnDismissed:^{
        [self.navigationController dismissViewControllerAnimated:NO completion:^
         {
             //[self requestUserInfo];
         }];
    }];
}

-(void)checkIfNeedsToContinue
{
    NSUInteger transportStatus = _user.transportstatus;
    if (transportStatus == 0) {
        return;
    }
    else if (transportStatus == 1){
        TranspotationPlanViewController *plan = [[TranspotationPlanViewController alloc] initWithStyle:UITableViewStylePlain];
        TransportDetail *detail = [[TransportDetail alloc] initWithID:_user.transportid];
        plan.detail = detail;
        [self.navigationController pushViewController:plan animated:YES];
    }
    else if (transportStatus >1 && transportStatus < 7)
    {
        QueueViewController* queue = [[QueueViewController alloc] initWithID:_user.transportid];
        [self.navigationController pushViewController:queue animated:YES];
    }
}

-(void)setAliasForNotification:(NSString*)alias
{
    NSString* aliasString = [NSString stringWithFormat:@"%@", alias];
    [JPUSHService setTags:nil alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
    }];
}


-(void)logout
{
    self.user = nil;
    _server.accessToken = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user_type"];
    [defaults removeObjectForKey:@"access_token"];
    
    [self requestUserInfo];
}

-(void)msgViewController
{
    MsgListViewController* msgView = [[MsgListViewController alloc] init];
    [self.navigationController pushViewController:msgView animated:YES];
}

#pragma mark right menu delegate
-(void)MenuView:(rightNavigationItem *)Menu selectIndexPath:(NSIndexPath *)indexPath
{
    [_popUpMenu dismiss];
    if (indexPath.row == 0) {
        [self navigateToQRScanner];
    }
    else
    {
        [self logout];
    }
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
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        [vc dismissViewControllerAnimated:YES completion:^{
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[resultAsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            _stats = [[LoadingStats alloc] init];
            
            if ([json objectForKey:@"city"]) {
                _stats.city = [[City alloc] init];
                _stats.city.cityid = [json objectForKey:@"city"];
            }
            if([json objectForKey:@"land"] && [json objectForKey:@"landId"])
            {
                _stats.field = [[Field alloc] init];
                _stats.field.fieldID = [[json objectForKey:@"landId"] integerValue];
                _stats.field.name = [json objectForKey:@"land"];
            }
            if([json objectForKey:@"provider"] && [json objectForKey:@"providerId"])
            {
                _stats.supplier = [[Vendor alloc] init];
                _stats.supplier.name = [json objectForKey:@"provider"];
                _stats.supplier.vendorID = [[json objectForKey:@"providerId"] integerValue];
                NSLog(@"%@, %@", [json objectForKey:@"provider"],_stats.supplier.name);
            }
            LoadingStatsViewController *loadingStats = [[LoadingStatsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            loadingStats.stats = _stats;
            [self.navigationController pushViewController:loadingStats animated:YES];
        }];
    }];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
