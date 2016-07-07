//
//  DriverDetailEditorController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DriverDetailEditorController.h"
#import "DriverDetailEditorCell.h"
#import "ServerManager.h"
#import "LoadingNav.h"
#import "UIImageView+WebCache.h"
#import "AlertHUDView.h"

#import "EditorNav.h"

#import "User.h"

@interface DriverDetailEditorController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,HUDViewDelegate>
{
    NSArray* titleText;
    NSArray* detailText;
    NSInteger index;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ServerManager* server;
@property (nonatomic, strong) User* driver;
@property AlertHUDView *alert;

@end

@implementation DriverDetailEditorController

-(void)viewDidLoad
{
    self.title = @"车主信息";
    titleText = @[@"头像",
                  @"车牌号",
                  @"司机姓名",
                  @"身份证",
                  @"驾驶证号",
                  @"行驶证号"];
    
    detailText = @[@"",
                   @"请输入6位车牌号",
                   @"请输入司机姓名",
                   @"请输入18位身份证号",
                   @"请输入驾驶证号",
                   @"请输入行驶证号"];
    
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
    
    _driver = [[User alloc] init];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, [DriverDetailEditorCell heightForCell]*6) style:UITableViewStylePlain];
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
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DriverDetailEditorCell heightForCell];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverDetailEditorCell* cell;
    if (indexPath.row ==0 ) {
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStyleAvatar reuseIdentifier:@"editor"];
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:_driver.avatar] placeholderImage:
         [UIImage imageNamed:@"default_avatar"]];
    }
    else if(indexPath.row ==1){
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStyleCarNumber reuseIdentifier:@"editor"];
    }
    else{
        cell = [[DriverDetailEditorCell alloc] initWithStyle: DriverDetailCellStylePlain reuseIdentifier:@"editor"];
    }
    
    NSString* title = [titleText objectAtIndex:indexPath.row];
    cell.titleLabel.text = title;
    
    NSString* detail = [detailText objectAtIndex:indexPath.row];
    if (![detail isEqualToString:@""]) {
        cell.detailLabel.text = detail;
        cell.detailLabel.delegate = self;
        cell.detailLabel.tag = indexPath.row;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverDetailEditorCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"tap");
    if (cell.style == DriverDetailCellStyleAvatar) {
        NSLog(@"did pick image");
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
    }
    NSLog(@"%lu", textField.tag);
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
    
    DriverDetailEditorCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    NSString* result = cell.detailLabel.text;
    NSString* detail = [detailText objectAtIndex:index];
    
    if ([result isEqualToString:detail]) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.title.text = @"出错啦";
        _alert.detail.text = @"请填写完整信息";
        _alert.delegate = self;
        [_alert show:_alert];
    }
    else
    {
        if(index == 1) //car no
        {
            _driver.carNo = result;
        }
        else if(index ==2)
        {
            _driver.driverName = result;
        }
        else if(index ==3)
        {
            _driver.cardID = result;
        }
        else if(index ==4)
        {
            _driver.driverNo = result;
        }
        else
        {
            _driver.licenseNo = result;
        }
        
        NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary: @{@"token":_server.accessToken}];
        NSDictionary* dic = @{@"carNo":_driver.carNo,
                              @"driverName":_driver.driverName,
                              @"cardId":_driver.cardID,
                              @"driverNo":_driver.driverNo,
                              @"licenseNo":_driver.licenseNo};
        [params addEntriesFromDictionary:dic];
        NSLog(@"params%@", params);
        [_server POST:@"registerComplete" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            EditorNav* editorNav = (EditorNav* )self.navigationController;

            if (editorNav.onDismissed) {
                editorNav.onDismissed();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }
    
}

#pragma mark pick image
-(void)didPickImage
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *UIAlertAction){
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
            [_driver setAvatar:responseObject[@"data"]];
            [_server POST:@"updateUserInfo" parameters:@{@"token":_server.accessToken,
                                                        @"avatar":_driver.avatar} animated:NO
                  success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject){
                      [self.tableView reloadData];
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
                  }];
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

@end
