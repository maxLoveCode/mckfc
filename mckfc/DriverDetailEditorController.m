//
//  DriverDetailEditorController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

//  这个修改司机的页面， 从 verif 的验证码页面和 homepage 首页都能跳进来，根据 registercomplete（详见.h 文件）来改变调用的接口
//  一共有两种接口，后台大哥规定是要登记完车辆信息才可以调用 update 改变头像，所以注意先后和 flag 值


#import "DriverDetailEditorController.h"
#import "DriverDetailEditorCell.h"
#import "ServerManager.h"
#import "LoadingNav.h"
#import "UIImageView+WebCache.h"
#import "AlertHUDView.h"

#import "EditorNav.h"
#import "CarPlateRegionSelector.h"

@interface DriverDetailEditorController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,HUDViewDelegate>
{
    NSArray* titleText;
    NSArray* detailText;
    NSInteger index;
}

@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) User* driver;
@property AlertHUDView *alert;

@end

@implementation DriverDetailEditorController

-(void)viewDidLoad
{
    self.title = @"车主信息";
//    titleText = @[@"头像",
//                  @"车牌号",
//                  @"司机姓名",
//                  @"身份证",
//                  @"驾驶证号",
//                  @"行驶证号"];
//    
//    detailText = @[@"",
//                   @"请输入6位车牌号",
//                   @"请输入司机姓名",
//                   @"请输入18位身份证号(选填)",
//                   @"请输入驾驶证号",
//                   @"请输入行驶证号(选填)"];
    
    titleText = @[@"车牌号",
                  @"司机姓名",
                  @"身份证号"];
    detailText = @[
                   @"请输入6位车牌号",
                   @"请输入司机姓名",
                   @"请输入18位身份证号",];
    
    _server = [ServerManager sharedInstance];
    
    [self.tableView registerClass:[DriverDetailEditorCell class] forCellReuseIdentifier:@"editor"];
    
    [self.view addSubview:self.tableView];
    
#pragma mark gestures
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];

#pragma mark navigationItem
    UIBarButtonItem* save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style: UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = save;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (!_driver) {
        _driver = [[User alloc] init];
    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, [DriverDetailEditorCell heightForCell]*3) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

#pragma mark UITableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DriverDetailEditorCell heightForCell];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverDetailEditorCell* cell;
//    if (indexPath.row ==0 ) {
//        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStyleAvatar reuseIdentifier:@"editor"];
//        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:_driver.avatar] placeholderImage:
//         [UIImage imageNamed:@"default_avatar"]];
//    }
//    else
    if(indexPath.row ==0){
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStyleCarNumber reuseIdentifier:@"editor"];
        [cell.popUpBtn addTarget:self action:@selector(popUpRegions:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStylePlain reuseIdentifier:@"editor"];
    }
    
    NSString* title = [titleText objectAtIndex:indexPath.row];
    cell.titleLabel.text = title;
    
    NSString* detail = [detailText objectAtIndex:indexPath.row];
    cell.detailLabel.delegate = self;
    cell.detailLabel.tag = indexPath.row;
    cell.detailLabel.textColor = COLOR_WithHex(0x565656);
    
    if (indexPath.row == 0) {
        NSLog(@"reload %@", _driver.region);
        cell.detailLabel.text = _driver.cardigits;
        cell.detailLabel.keyboardType = UIKeyboardTypeASCIICapable;
        
        if (_driver.region && ![_driver.region isEqualToString:@""]) {
            [cell.popUpBtn setSelected:YES];
            [cell.popUpBtn setTitle:_driver.region forState:UIControlStateSelected];
        }
        else
        {
            NSLog(@"%@",cell.popUpBtn);
        }
    }
    else if(indexPath.row == 1){
        cell.detailLabel.text = _driver.driver;
    }
    else if(indexPath.row == 2){
        cell.detailLabel.text = _driver.idcard;
        cell.detailLabel.keyboardType = UIKeyboardTypeAlphabet;
    }
    else if(indexPath.row == 4){
        cell.detailLabel.text = _driver.driverno;
        cell.detailLabel.keyboardType = UIKeyboardTypeNumberPad;
    }else{
         cell.detailLabel.text = _driver.licenseno;
        cell.detailLabel.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if ([cell.detailLabel.text isEqualToString:@""]) {
        cell.detailLabel.text = detail;
        cell.detailLabel.textColor = COLOR_TEXT_GRAY;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverDetailEditorCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.style == DriverDetailCellStyleAvatar) {
        [self didPickImage];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString* detail = [detailText objectAtIndex:textField.tag];
    if ([textField.text isEqualToString:detail]) {
        textField.text = @"";
    }
    index = textField.tag;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* detail = [detailText objectAtIndex:textField.tag];
    if ([textField.text isEqualToString:@""]) {
        textField.text = detail;
        textField.textColor = COLOR_TEXT_GRAY;
    }
    else
    {
        textField.textColor = COLOR_WithHex(0x565656);
    }
    
    DriverDetailEditorCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSString* result = cell.detailLabel.text;
    
        if(index == 0) //car no
        {
            _driver.cardigits = result;
        }
        else if(index ==1)
        {
            _driver.driver = result;
        }
        else if(index ==2)
        {
            _driver.idcard = result;
        }
//        else if(index ==2)
//        {
//            _driver.driverno = result;
//        }
//        else
//        {
//            NSLog(@"%@", result);
//            _driver.licenseno = result;
//        }
}

#pragma mark gesture
-(void)dismissKeyboard
{
    if (index!=0) {
        DriverDetailEditorCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell.detailLabel resignFirstResponder];
    }
   
}

#pragma mark save info
-(void)save
{
    [self dismissKeyboard];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary: @{@"token":_server.accessToken}];
    
    if (!_driver.driver) {
        _driver.driver = @"未命名司机";
    }
    if (!_driver.licenseno) {
        _driver.licenseno = @"";
    }
    if (!_driver.idcard) {
        _driver.idcard = @"";
    }
    if (!_driver.driverno) {
        _driver.driverno = @"";
    }
    
    if (!_driver.region || !_driver.cardigits) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.delegate = self;
        _alert.title.text = @"信息错误";
        _alert.detail.text = @"请填写车牌号";
        [_alert show:_alert];
        return;
    }
    
    NSString* url;
    
    if (self.registerComplete) {
        url = @"updateUserInfo";
    }
    else //verifyview navs
    {
        url =@"registerComplete";
    }
    
    
    NSDictionary* dic = @{@"truckno":[NSString stringWithFormat:@"%@%@",_driver.region, _driver.cardigits],
                              @"driver":_driver.driver,
                              @"idcard":_driver.idcard,
                              @"driverno":_driver.driverno,
                              @"licenseno":_driver.licenseno};
        [params addEntriesFromDictionary:dic];
    NSLog(@"params:%@", params);
        [_server POST:url parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            if (_driver.avatar) {
                [_server POST:@"updateUserInfo" parameters:@{@"token":_server.accessToken,
                                                             @"avatar":_driver.avatar} animated:NO
                      success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject){
                          
                          EditorNav* editorNav = (EditorNav* )self.navigationController;
                          
                          if (editorNav.onDismissed) {
                              editorNav.onDismissed();
                          }
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                }];
            }
            else
            {
                EditorNav* editorNav = (EditorNav* )self.navigationController;

                if (editorNav.onDismissed) {
                    editorNav.onDismissed();
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
}

#pragma mark pick image
-(void)didPickImage
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_server upLoadImageData:img forSize:CGSizeMake(100, 100) success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [_driver setAvatar:responseObject[@"data"]];
            [self.tableView reloadData];
            if (!_registerComplete) {
                [_server POST:@"updateUserInfo" parameters:@{@"token":_server.accessToken,
                                                             @"avatar":_driver.avatar} animated:NO
                      success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject){
                          
                          NSLog(@"%@",responseObject);
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectConfirm
{
    if (self.alert) {
        [self.alert removeFromSuperview];
    }
}

#pragma mark set content
-(void)setUser:(User*)user
{
    self.driver = user;
    if (user.truckno && ![user.truckno isEqualToString:@""]) {
        self.driver.region = [user.truckno substringWithRange:NSMakeRange(0, 1)];
        self.driver.cardigits = [user.truckno substringWithRange:NSMakeRange(1, [user.truckno length])];
    }
    [self.tableView reloadData];
}

#pragma mark popUp menu
-(void)popUpRegions:(id)sender
{
    [_server GET:@"getRegionList"
      parameters:@{@"token":_server.accessToken}
        animated:YES
         success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
             
        CarPlateRegionSelector* selector = [[CarPlateRegionSelector alloc] init];
        [selector setRegions:responseObject[@"data"]];
        [selector show];
       
        //return block
        __weak User* weakref = self.driver;
        [selector setSelectBlock:^(NSString *result) {
            weakref.region = result;
            UIButton* button = sender;
            button.selected = YES;
            [_tableView reloadData];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
