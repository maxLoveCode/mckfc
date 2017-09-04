//
//  MakeConcessionsViewController.m
//  mckfc
//
//  Created by 华印mac－002 on 2017/8/1.
//  Copyright © 2017年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "MakeConcessionsViewController.h"
#import "ServerManager.h"
@interface MakeConcessionsViewController ()<UITextViewDelegate>
@property (nonatomic, strong) ServerManager* server;
@end

@implementation MakeConcessionsViewController{
    UITextView *_textView;
    UIButton * _sureBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"让步缘由";
    _server = [ServerManager sharedInstance];
    [self setTextView];
    [self addGesture];
    [self setupSureBtn];
    // Do any additional setup after loading the view.
}

- (void)setInsepection:(InspectionReport *)insepection{
    _insepection = insepection;
    if ([insepection.status isEqualToNumber:@2] && insepection.refusecause) {
        _textView.text = insepection.refusecause;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setupSureBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, CGRectGetMaxY(_textView.frame)+ 20, kScreen_Width - 30, 40);
    btn.backgroundColor = COLOR_THEME;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn setTitleColor:COLOR_WITH_RGB(99, 48, 16) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitle:@"确认并提交" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    _sureBtn = btn;
    if ([self.mainType isEqualToString:self.type]) {
        _sureBtn.hidden = NO;
    }else{
        _sureBtn.hidden = YES;
    }
}

- (void)setTextView{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 30, kScreen_Width - 30, 150)];
    textView.layer.masksToBounds = YES;
    textView.layer.borderWidth = 1;
    textView.returnKeyType = UIReturnKeyDone;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.delegate = self;
    [textView.layer setCornerRadius:5];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if ([_insepection.status isEqualToNumber:@2]) {
        textView.text = _insepection.refusecause;
    }else{
        textView.text = _insepection.refusecause;
    }
    [self.view addSubview:textView];
    _textView = textView;
    
}

#pragma mark -- 事件
- (void)sureEvent{
    NSLog(@"确定");
    if (_textView.text) {
        _insepection.refusecause = _textView.text;
    }else{
        _insepection.refusecause = @"";
    }
    _insepection.status = @2;
    
    NSMutableDictionary* params =[[NSMutableDictionary alloc] initWithDictionary: [MTLJSONAdapter JSONDictionaryFromModel:_insepection error:nil]];
    [params addEntriesFromDictionary:@{@"type":self.mainType,
                                       @"token":_server.accessToken,
                                       @"transportid":self.transportid}];
    NSLog(@"-----params%@", params);
    [_server POST:@"truckCheck" parameters:params animated:YES success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"++++++%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickReturnKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)clickReturnKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - 键盘监听事件

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
