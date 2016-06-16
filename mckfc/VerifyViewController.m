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
    
    NSLog(@"%@",defaultText);
    _server = [ServerManager sharedInstance];
    
    self.view = self.verifyView;
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
        NSLog(@"here %@", defaultText);
        for (int i=0; i<defaultText.count; i++) {
            NSLog(@"asdf");
            UIView* view = [_verifyView viewWithTag:i+1];
            NSLog(@"%@",view);
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField* textField = (UITextField*)view;
                textField.text = defaultText[i];
                textField.delegate = self;
            }
        }
        
        [_verifyView.resend addTarget:self action:@selector(resend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyView;
}

-(void)setText:(NSString *)text
{
    self.verifyView.label.text = text;
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
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(fireTimer) userInfo:nil repeats:NO];
    }
}

-(void)fireTimer
{
    NSLog(@"fire");
    if (!_startDate) {
        _startDate = [NSDate date];
    }
    else
    {
        NSTimeInterval timeInterval = -[_startDate timeIntervalSinceNow];
        NSLog(@"%lf", timeInterval);
    }
}

@end
