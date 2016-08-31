//
//  ForgotPasswordViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ServerManager.h"

#define timeInterval 60

@interface ForgotPasswordViewController ()

@property (nonatomic, strong) ServerManager* server;

@end

@implementation ForgotPasswordViewController
{
    NSArray* defaultArray;
    NSString* mobile;
    NSString* vericode;
    NSString* password;
    NSString* repass;
}

-(void)viewDidLoad
{
    self.title = @"忘记密码";
    
//    defaultText  = @"请输入手机号";
    _server = [ServerManager sharedInstance];
//
    defaultArray = @[@"请输入手机号",@"请输入验证码",@"请输入新密码",@"请再输入一次密码"];
    
    self.view = self.forgotPassView;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view setAlpha:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setAlpha:1];
}

-(ForgotPasswordView *)forgotPassView
{
    if (!_forgotPassView) {
        _forgotPassView = [[ForgotPasswordView alloc] init];
        for (UIView* view in [_forgotPassView subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField* textField = (UITextField*)view;
                textField.delegate = self;
                textField.text = defaultArray[textField.tag -1];
            }
        }
        [_forgotPassView.confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        [_forgotPassView.vericode addTarget:self action:@selector(sendVeri:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPassView;
}

-(void)confirm:(id)sender
{
    if ([self checkValidation]) {
        
    }
}

-(void)sendVeri:(id)sender
{
    for (UIView* view in [_forgotPassView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField* textField = (UITextField*)view;
            if(textField.tag == 1)
            {
                mobile = textField.text;
            }
        }
    }
    NSDictionary* params = @{@"mobile":mobile};
    NSLog(@"%@",params);
    [_server POST:@"sendForgetCaptcha" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        [self setTimer];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(BOOL)checkValidation
{
    for (UIView* view in [_forgotPassView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField* textField = (UITextField*)view;
            if ([textField.text isEqualToString:defaultArray[textField.tag -1]]) {
                return NO;
            }
            else
            {
                if (textField.tag == 1) {
                    mobile = textField.text;
                }
                else if(textField.tag ==2){
                    vericode = textField.text;
                }
                else if(textField.tag ==3){
                    password = textField.text;
                }
                else
                {
                    repass = textField.text;
                }
                
                if (![password isEqualToString:repass]) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark- textField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = defaultArray[textField.tag -1];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:defaultArray[textField.tag -1]]) {
        textField.text = @"";
    }
}

-(void)setTimer
{
    
    NSDate* schedualDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fire:) userInfo:@{@"schedualDate":schedualDate} repeats:YES];
}

-(void)fire:(id)sender
{
    NSLog(@"fire");
    NSTimer* timer = (NSTimer*)sender;
    
    NSDate* schedualDate = [timer.userInfo objectForKey:@"schedualDate"];
    CGFloat interval = timeInterval-[timer.fireDate timeIntervalSinceDate:schedualDate];
    NSLog(@"%lf", interval);
    UIButton* button = _forgotPassView.vericode;
    if (interval>0) {
        button.enabled = NO;
        [button setTitle:[NSString stringWithFormat:@"%i后可重新发送",(int)interval] forState:UIControlStateDisabled];
        [button setBackgroundColor:[UIColor grayColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    else
    {
        [timer invalidate];
        button.enabled = YES;
        [button setBackgroundColor:COLOR_THEME];
        button.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
}



@end
