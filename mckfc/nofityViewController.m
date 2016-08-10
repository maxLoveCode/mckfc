//
//  nofityViewController.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/10.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "nofityViewController.h"

@implementation nofityViewController

-(instancetype)initWithString:(NSString*)source
{
    self.title = @"入场须知";
    self = [super init];
    self.source = source;
    return self;
}

-(void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIWebView* webview =[[UIWebView alloc] init];
    [webview setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64)];
    [webview loadHTMLString:_source baseURL:nil];
    [self.view addSubview:webview];
    //UIWebView
}

@end
