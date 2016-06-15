//
//  ViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/6/12.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "UserView.h"

@interface ViewController ()
@property (nonatomic, strong) UserView* userview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _userview = [[UserView alloc] init];
    self.view = _userview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
