//
//  VerifyViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/16.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "VerifyViewController.h"
#import "ServerManager.h"
#import "VerifyView.h"
#import "EditorNav.h"

#import "DriverDetailEditorController.h"

@interface VerifyViewController()<UITextFieldDelegate>
{
    NSArray* defaultText;
}

@property (nonatomic, strong) VerifyView* verifyView;
@property (strong, nonatomic) ServerManager* server;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) NSDate* startDate;

@end

@implementation VerifyViewController

-(instancetype)init
{
    self = [super init];
    
    defaultText = @[@"请输入验证码", @"请输入密码"];
    return self;
}

-(void)viewDidLoad
{
    self.title = @"输入验证码";
    
    _server = [ServerManager sharedInstance];
    
    self.view = self.verifyView;
    [self resend];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view setAlpha:0];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view setAlpha:1];
}

#pragma mark setter
-(VerifyView *)verifyView
{
    if (!_verifyView) {
        _verifyView = [[VerifyView alloc] init];
        for (int i=0; i<defaultText.count; i++) {
            UIView* view = [_verifyView viewWithTag:i+1];
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField* textField = (UITextField*)view;
                textField.text = defaultText[i];
                textField.delegate = self;
            }
        }
        
        [_verifyView.resend addTarget:self action:@selector(resend) forControlEvents:UIControlEventTouchUpInside];
        [_verifyView.confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyView;
}

-(void)setText:(NSString *)text
{
    self.verifyView.label.text = [NSString stringWithFormat:@"验证码已发送至手机号： %@", text];;
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:defaultText[textField.tag-1]]) {
        textField.text = @"";
    }
    if (textField.tag == 2) {
        textField.secureTextEntry = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        if (textField.tag == 2) {
            textField.secureTextEntry = NO;
        }
        textField.text = defaultText[textField.tag-1];
    }
}

#pragma mark gesture
-(void)dismissKeyboard
{
    [self.verifyView.code resignFirstResponder];
    [self.verifyView.password resignFirstResponder];
}

#pragma mark buttons
-(void)resend
{
    NSLog(@"resend");
    if (!_timer) {
        NSLog(@"resend1");
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fireTimer) userInfo:nil repeats:YES];
    }
    else
    {
        NSLog(@"resend2");
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fireTimer) userInfo:nil repeats:YES];
        NSDictionary* params = @{@"mobile":_mobile};
        [_server POST:@"sendRegisterCaptcha" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

-(void)fireTimer
{
    if (!_startDate) {
        _startDate = [NSDate date];
    }
    
    NSTimeInterval timeInterval = -[_startDate timeIntervalSinceNow];
    if (timeInterval>60) {
        [_timer invalidate];
        _startDate = nil;
        _verifyView.resend.enabled = YES;
        [_verifyView.resend setBackgroundColor:COLOR_THEME];
        _verifyView.resend.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    else
    {
        _verifyView.resend.enabled = NO;
        [_verifyView.resend setTitle:[NSString stringWithFormat:@"%i秒后可重新发送", (int)((60-timeInterval)*100000)/100000] forState: UIControlStateDisabled];
        _verifyView.resend.titleLabel.font = [UIFont systemFontOfSize:12];
        [_verifyView.resend setBackgroundColor:[UIColor grayColor]];
        [_verifyView.resend setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }

}


#pragma mark submit
-(void)confirm
{
    [self dismissKeyboard];
    NSDictionary* params = @{@"mobile":_mobile,
                          @"password":_verifyView.password.text,
                          @"captcha":_verifyView.code.text};
    [_server POST:@"register" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 10000) {
            
            NSString* token = [[responseObject objectForKey:@"data"] objectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"access_token"];
            _server.accessToken = token;
            EditorNav* EditorVC = [[EditorNav alloc] init];
            DriverDetailEditorController* driverVC =(DriverDetailEditorController*)EditorVC.topViewController;
            [driverVC setRegisterComplete:YES];
            
            [self.navigationController presentViewController:EditorVC animated:YES completion:^{
                
            }];
            [EditorVC setOnDismissed:^{
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
