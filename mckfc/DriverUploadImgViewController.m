//
//  DriverUploadImgViewController.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/7/14.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "DriverUploadImgViewController.h"
#import "WSImagePickerView.h"
#import "ServerManager.h"
#import "FarmerViewModel.h"
#import "AlertHUDView.h"
@interface DriverUploadImgViewController ()<HUDViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHieghtConstraint;
@property (nonatomic, strong) WSImagePickerView *pickerView;
@property (nonatomic, strong) ServerManager *serverManager;
@property (weak, nonatomic) IBOutlet UITextField *driverNumberTextfield;
@property (nonatomic, strong) FarmerViewModel *farmVM;
@end

@implementation DriverUploadImgViewController{
    AlertHUDView *_alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传图片";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Number",self.fielduserid]]) {
        _driverNumberTextfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Number",self.fielduserid]];
    }
    [self setupPickerView];
    [self addNotificationCenter];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotificationCenter{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 键盘将出现事件监听
    
    [center addObserver:self selector:@selector(handleKeyboardWillShow:)
     
                   name:UIKeyboardWillShowNotification
     
                 object:nil];
    
    // 键盘将隐藏事件监听
    
    [center addObserver:self selector:@selector(handleKeyboardWillHide:)
     
                   name:UIKeyboardWillHideNotification
     
                 object:nil];
}

- (FarmerViewModel *)farmVM{
    if (!_farmVM) {
        self.farmVM = [[FarmerViewModel alloc]init];
    }
    return _farmVM;
}

- (ServerManager *)serverManager{
    if (!_serverManager) {
        self.serverManager = [ServerManager sharedInstance];
    }
    return _serverManager;
}

- (void)setupPickerView {
    
    //imagePickerView parameter settings
    WSImagePickerConfig *config = [WSImagePickerConfig new];
    config.itemSize = CGSizeMake(80, 80);
    config.photosMaxCount = 9;
    
    WSImagePickerView *pickerView = [[WSImagePickerView alloc] initWithFrame:CGRectMake(0, 0,kScreen_Width , 0) config:config fielduserid:self.fielduserid];
    //Height changed with photo selection
    __weak typeof(self) weakSelf = self;
    pickerView.viewHeightChanged = ^(CGFloat height) {
        weakSelf.photoViewHieghtConstraint.constant = height;
        [weakSelf.view setNeedsLayout];
        [weakSelf.view layoutIfNeeded];
    };
    pickerView.navigationController = self.navigationController;
    [self.photoView addSubview:pickerView];
    self.pickerView = pickerView;
    
    //refresh superview height
    [pickerView refreshImagePickerViewWithPhotoArray:nil];
}

- (IBAction)onClickConfirm:(id)sender {
    if ([_driverNumberTextfield.text isEqualToString:@"请填写司机人数"] || [_driverNumberTextfield.text isEqualToString:@""]) {
        [self showAlert];
        return;
    }
    NSArray *array = [_pickerView getPhotos];
    if (!array.count || array.count == 0 ) {
        return;
    }
    NSMutableArray *dataImg = [NSMutableArray array];
    NSLog(@"%@",array);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < array.count; i++) {
        UIImage *img = array[i];
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            [self.serverManager upLoadImageData:img forSize:img.size success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [dataImg addObject:responseObject[@"data"]];
                dispatch_group_leave(group);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"执行完毕");
        NSLog(@"11111%@111111",dataImg);
        [[NSUserDefaults standardUserDefaults]setValue:dataImg forKey:self.fielduserid];
        [[NSUserDefaults standardUserDefaults]setValue:_driverNumberTextfield.text forKey:[NSString stringWithFormat:@"%@Number",self.fielduserid]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSMutableString *mutStr = [NSMutableString string];
        for (NSString *str in dataImg) {
            [mutStr appendFormat:@"%@,",str];
        }
        [mutStr deleteCharactersInRange:NSMakeRange([mutStr length] - 1, 1)];
        [self.farmVM uploadFieldImage:self.fielduserid drivernum:_driverNumberTextfield.text urls:mutStr success:^(NSString *msg) {
             [self.navigationController popViewControllerAnimated:NO];
        }];
       
    });


}

-(void)tapClick{
    [self.view endEditing: YES];
}

// 键盘弹出时
-(void)handleKeyboardWillShow:(NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(tapClick)];
}

//键盘消失时
-(void)handleKeyboardWillHide:(NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)showAlert{
    [self.view endEditing:YES];
    _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain
              ];
    _alert.delegate = self;
    _alert.title.text = @"上传图片";
    _alert.detail.text = @"请填写司机人数";
    [_alert show:_alert];
}

- (void)didSelectConfirm{
    [_alert dismiss:_alert];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
