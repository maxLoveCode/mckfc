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

#import "EditorNav.h"

#import "User.h"

@interface HomepageViewController ()<UserViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UserView* userview;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) User* user;

@end

@implementation HomepageViewController

-(void)viewDidLoad
{
    self.title = @"首页";
    _userview = [[UserView alloc] init];
    _server = [ServerManager sharedInstance];
    
    _userview.delegate = self;
    
    
    [self requestUserInfo];
    
    self.view = _userview;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
            [_userview setContentByUser:_user];
            NSLog(@"%@",_user);
            [self checkIfNeedsToUpdateUser];
            [self checkIfNeedsToContinue];
                
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    else{
        NSLog(@"login");
        LoginNav* loginVC = [[LoginNav alloc] init];
        [self presentViewController:loginVC animated:NO completion:^{
            }];
    }
}

-(void)didClickConfirm
{
    LoadingStatsViewController *loadingStats = [[LoadingStatsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:loadingStats animated:YES];
}

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
        EditorNav* editVC = [[EditorNav alloc] init];
        DriverDetailEditorController* driverVC =(DriverDetailEditorController*)editVC.topViewController;
        [driverVC setUser:_user];
        [driverVC setRegisterComplete:YES];
        [self.navigationController presentViewController:editVC animated:YES completion:^{
            
        }];
        [editVC setOnDismissed:^{
            [self.navigationController dismissViewControllerAnimated:NO completion:^
             {
                 //[self requestUserInfo];
             }];
        }];
    }
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

@end
