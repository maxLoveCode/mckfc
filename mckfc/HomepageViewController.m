//
//  HomepageViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/15.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//
#import "HomepageViewController.h"
#import "FarmerViewModel.h"
@interface HomepageViewController ()<UserViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,menuDelegate,QRCodeReaderDelegate,HUDViewDelegate>

@property (nonatomic, strong) UserView* userview;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) rightNavigationItem* popUpMenu;
@property (nonatomic, strong) LoadingStats* stats;

@property (nonatomic, strong) AlertHUDView* alert;
@property (nonatomic, strong) RedPocketButton* redPocket;
@property (nonatomic, strong) FarmerViewModel *farmerVM;
@end

@implementation HomepageViewController

-(void)viewDidLoad
{
    self.title = @"首页";
    _userview = [[UserView alloc] init];
    _server = [ServerManager sharedInstance];
    
    _userview.delegate = self;
    [_userview.botBtn addTarget:self action:@selector(notifypage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = self.popUpMenu;
    
    
    self.view = _userview;
    
    [self.redPocket attachToView:self.view];
    [self.redPocket setHidden:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账户修改" style:UIBarButtonItemStylePlain target:self action:@selector(editDriverMes)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_user) {
        [self requestUserInfo];
    }
    
    [self remoteNotification];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationRefresh object:nil];
}

#pragma mark - setter properties

- (FarmerViewModel *)farmerVM{
    if (!_farmerVM) {
        self.farmerVM = [[FarmerViewModel alloc] init];
    }
    return _farmerVM;
}
-(AlertHUDView *)alert
{
    if (!_alert) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.delegate = self;
    }
    return _alert;
}

-(rightNavigationItem *)popUpMenu
{
    if (!_popUpMenu) {
        _popUpMenu = [[rightNavigationItem alloc] initCutomItemAtHomepage];
        _popUpMenu.ItemStyle = navItemStyleHomepage;
        _popUpMenu.delegate =self;
    }
    return _popUpMenu;
}

-(RedPocketButton *)redPocket
{
    if (!_redPocket) {
        _redPocket = [[RedPocketButton alloc] init];
    }
    return _redPocket;
}


-(void)requestUserInfo
{
    //根据 access token 判断第一次
    if (_server.accessToken) {
        NSDictionary* params = @{@"token": _server.accessToken};
        [_server GET:@"getUserInfo" parameters:params animated:NO success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"] integerValue] == 10003) {
                [self navigateToEditor];
                return;
            }
            
            NSError* error;
            NSDictionary* data = responseObject[@"data"];
            _user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            [_userview setContentByUser:_user];
    
            
            if (_user.type != [MKUSER_TYPE_DRIVER integerValue]) {
                LoginNav* loginVC = [[LoginNav alloc] init];
                [self presentViewController:loginVC animated:NO completion:^{
                }];
            }
            else
            {
                [self checkIfNeedsToUpdateUser];
                [self checkRedPocketByUser:_user];
                [self checkIfNeedsToContinue];
                [self setAliasForNotification:data[@"userid"]];
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

- (void)editDriverMes{
    EditorNav* editVC = [[EditorNav alloc] init];
    DriverDetailEditorController* driverVC =(DriverDetailEditorController*)editVC.topViewController;
    [driverVC setUser:_user];
    [driverVC setRegisterComplete:YES];
    [self.navigationController presentViewController:editVC animated:YES completion:^{
        
    }];
    [editVC setOnDismissed:^{
        [self.navigationController dismissViewControllerAnimated:NO completion:^
         {
             [self requestUserInfo];
         }];
    }];
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
             [self requestUserInfo];
         }];
    }];
}

-(void)checkIfNeedsToContinue
{
    NSUInteger transportStatus = _user.transportstatus;
    if (transportStatus == 0) {
        NSString* isRead = [[NSUserDefaults standardUserDefaults] objectForKey:isReadFactoryNotification];
        if ( [isRead isEqualToString:@"0"] || isRead == nil) {
            [self readBookletPrompt];
        }
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
    else if(indexPath.row == 1){
        MsgListViewController* msgVC = [[MsgListViewController alloc] init];
        [self.navigationController pushViewController:msgVC animated:YES];
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
        
            if([[json objectForKey:@"providerId"] isEqualToString:@"0"]  && [json objectForKey:@"landId"] ){
                [self.farmerVM getarrivedFieldData:[json objectForKey:@"landId"] :^(NSString *msg){
                    NSLog(@"+++++");
                    self.alert.title.text = @"扫码正确";
                    self.alert.detail.text = msg;
                     self.alert.detail.numberOfLines = 0;
                     self.alert.tag = 1;
                    [self.alert show:_alert];
                      return;
                } error:^(NSString *msg) {
                    
                }];
            }else{

            if([json objectForKey:@"mobile"])
            {
                if(![[json objectForKey:@"mobile"] isEqualToString:_user.mobile])
                {
                    NSLog(@"%@   %@",[json objectForKey:@"mobile"],_user.mobile);
                    
                    self.alert.title.text = @"扫码错误";
                    self.alert.detail.text = @"司机手机号不匹配";
                    self.alert.detail.numberOfLines = 0;
                    self.alert.tag = 1;
                    [self.alert show:_alert];
                    
                    return;
                }
            }
            if([json objectForKey:@"truckno"])
            {
                if(![[json objectForKey:@"truckno"] isEqualToString:_user.truckno])
                {
                    NSLog(@"%@   %@",[json objectForKey:@"truckno"],_user.truckno);
                    
                    self.alert.title.text = @"扫码错误";
                    self.alert.detail.text = @"司机车牌号不匹配";
                    self.alert.detail.numberOfLines = 0;
                    self.alert.tag = 1;
                    [self.alert show:_alert];
                    
                    return;
                }
            }
            //如果有城市
            if ([json objectForKey:@"city"]) {
                _stats.city = [[City alloc] init];
                _stats.city.areaid = [json objectForKey:@"city"];
            }
            //如果有地块
            if([json objectForKey:@"land"] && [json objectForKey:@"landId"])
            {
                _stats.field = [[Field alloc] init];
                _stats.field.fieldID = [[json objectForKey:@"landId"] integerValue];
                _stats.field.name = [json objectForKey:@"land"];
            }
            //如果有供应商
            if([json objectForKey:@"provider"] && [json objectForKey:@"providerId"])
            {
                _stats.supplier = [[Vendor alloc] init];
                _stats.supplier.name = [json objectForKey:@"provider"];
                _stats.supplier.vendorID = [[json objectForKey:@"providerId"] integerValue];
            }
            //还差重量，发运时间，和运单号
            if ([json objectForKey:@"weight"]) {
                _stats.weight = [json objectForKey:@"weight"];
            }
            if ([json objectForKey:@"serialno"] || ![[json objectForKey:@"serialno"] isEqualToString:@""]) {
                _stats.serialno = [json objectForKey:@"serialno"];
            }
            if ([json objectForKey:@"departuretime"])
            {
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                _stats.departuretime = [dateFormatter dateFromString:[json objectForKey:@"departuretime"]];
                
            }
            if ([json objectForKey:@"planarrivetime"])
                {
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    _stats.planarrivetime = [dateFormatter dateFromString:[json objectForKey:@"planarrivetime"]];
            }
            if ([json objectForKey:@"packageid"] && [json objectForKey:@"packagename"] )
            {
                _stats.package = [[Package alloc] init];
                _stats.package.name = [json objectForKey:@"packagename"];
                _stats.package.packageid = [json objectForKey:@"packageid"];
            }
            if ([json objectForKey:@"factoryid"] && [json objectForKey:@"factoryname"] )
            {
                _stats.factory = [[Factory alloc] init];
                _stats.factory.name = [json objectForKey:@"factoryname"];
                _stats.factory.factoryid = [json objectForKey:@"factoryid"];
            }
            if ([json objectForKey:@"varietyid"] && [json objectForKey:@"varietyname"] )
                {
                    _stats.variety = [[Variety alloc] init];
                    _stats.variety.name = [json objectForKey:@"varietyname"];
                    _stats.variety.varietyid = [json objectForKey:@"varietyid"];
            }
            if ([json objectForKey:@"storageid"] && [json objectForKey:@"storagename"] )
            {
                    _stats.storage = [[Storage alloc] init];
                    _stats.storage.name = [json objectForKey:@"storagename"];
                    _stats.storage.storageid = [json objectForKey:@"storageid"];
            }
            LoadingStatsViewController *loadingStats = [[LoadingStatsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            loadingStats.stats = _stats;
            [self.navigationController pushViewController:loadingStats animated:YES];
            if([loadingStats.stats validForStartingTransport])
            {
                [loadingStats confirmBtn];
            }
            }
        }];
        
    }];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - notifypage
-(void)notifypage:(id)sender
{
    if (_user.factorynotes != nil) {
        nofityViewController* notify = [[nofityViewController alloc] initWithString:_user.factorynotes];
        [self.navigationController pushViewController:notify animated:YES];
    }
}

#pragma mark-alertview delegate
-(void)didSelectConfirm
{
    if (self.alert.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:isReadFactoryNotification];
        [self notifypage:nil];
    }
    else
    {
        
    }
    
    [self.alert removeFromSuperview];
}

#pragma mark- Read Booklet
-(void)readBookletPrompt
{
    self.alert.title.text = @"入场须知";
    self.alert.detail.text = @"司机请查看入场须知";
    self.alert.detail.numberOfLines = 0;
    self.alert.tag = 0;
    [self.alert show:_alert];
}

#pragma mark- redPocket
//firstly check the red pocket is need to be hidden or not
-(void)checkRedPocketByUser:(User*)user
{
    if([user.redrule isEqualToString:@""]||user.redrule == nil)
    {
        [self.redPocket setHidden:YES];
    }
    else
    {
        [self.redPocket setHidden:NO];
        [self.redPocket setString:user.reward];
        [self.redPocket.claim addTarget:self action:@selector(claim:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark- claim +modal view
//its the modal uiview to present so I put the ui rendering inside the method
-(void)claim:(id)sender
{
    RewardDetailView* rewardView = [[RewardDetailView alloc] init];
    [rewardView show];

    [rewardView setContentString:_user.redrule];
}

#pragma mark- remote notification
-(void)remoteNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:notificationRefresh object:nil];
    
}

-(void)getNotification:(NSNotification *)notification
{
    if([notification.userInfo[@"content"] isEqualToString:@"userrefresh"])
    {
        [self requestUserInfo];
    }
}
@end
