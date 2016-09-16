
//
//  ChangePasswordViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/9/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ServerManager.h"
#import "ChangePassView.h"
#import "AlertHUDView.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate,HUDViewDelegate>

@property (nonatomic, strong) ServerManager* serverManager;
@property (nonatomic, strong) ChangePassView* changePassView;
@property (nonatomic, strong) AlertHUDView* alert;

@end

@implementation ChangePasswordViewController
{
    NSArray* defaultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _serverManager = [ServerManager sharedInstance];
    defaultArray = @[@"请输入原密码",@"请输入新密码",@"请再输入一次密码"];
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    bgView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:bgView];
    [self.view addSubview:self.changePassView];
    [self.view updateConstraintsIfNeeded];
    self.title = @"修改密码";
}

-(AlertHUDView *)alert
{
    if (!_alert) {
        _alert = [[AlertHUDView alloc] initWithStyle:HUDAlertStylePlain];
        _alert.title.text = @"错误";
        _alert.delegate = self;
    }
    return _alert;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(ChangePassView *)changePassView
{
    if (!_changePassView) {
        _changePassView = [[ChangePassView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        for (UIView* view in [_changePassView subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField* textField = (UITextField*)view;
                textField.delegate = self;
                textField.text = defaultArray[textField.tag -1];
            }
        }
        [_changePassView.confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changePassView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)confirm:(id)sender
{
    [self.view endEditing:YES];
    [self postRequestToServer];
}

-(void)postRequestToServer
{
    NSDictionary* params = [self checkValidation];
    NSLog(@"%@",params);
    if (params) {
        [self.serverManager POST:@"chgPassword" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            self.alert.title.text = @"成功";
            self.alert.detail.text = @"修改成功";
            self.alert.tag = 3;
            [self.alert show:self.alert];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

#pragma mark- textField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = defaultArray[textField.tag -1];
        
        
        textField.secureTextEntry = NO;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:defaultArray[textField.tag -1]]) {
        textField.text = @"";
        
        textField.secureTextEntry = YES;
    }
}

-(NSDictionary*)checkValidation
{
    NSString* oldpass;
    NSString* newpass;
    NSString* repass;
    for (UIView* view in [_changePassView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField* textField = (UITextField*)view;
            if ([textField.text isEqualToString:defaultArray[textField.tag -1]]) {
                _alert.title.text = @"错误";
                self.alert.detail.text = textField.text;
                self.alert.tag = 1;
                [self.alert show:self.alert];
                return nil;
            }
            else
            {
                if (textField.tag == 1) {
                    oldpass = textField.text;
                }
                else if(textField.tag ==2){
                    newpass = textField.text;
                }
                else if(textField.tag ==3){
                    repass = textField.text;
                }
                
            }
        }
    }
    
    if (![newpass isEqualToString:repass]) {
        _alert.title.text = @"错误";
        self.alert.detail.text = @"两次密码不一致";
        self.alert.tag = 1;
        [self.alert show:self.alert];
        return nil;
    }
    return @{@"password":oldpass,@"newpassword":newpass,@"token":_serverManager.accessToken,};
}

#pragma mark -alertview delegate
-(void)didSelectConfirm
{
    [self.alert removeFromSuperview];
    if (self.alert.tag == 3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
