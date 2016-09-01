//
//  RewardDetailView.m
//  mckfc
//
//  Created by 华印mac-001 on 16/9/1.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "RewardDetailView.h"

@interface RewardDetailView ()

@property (strong, nonatomic) UIImageView* bg_view;
@property (strong, nonatomic) UIWebView* content;
@property (strong, nonatomic) UIImageView* titleView;
@property (strong, nonatomic) UIButton* reward;

@end

@implementation RewardDetailView

-(instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.bg_view];
        [self.bg_view addSubview:self.content];
        [self.bg_view addSubview:self.titleView];
        [self.bg_view addSubview:self.reward];
    }

    return self;
}

-(UIImageView *)bg_view
{
    if (!_bg_view) {
        _bg_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rules_bg"]];
        _bg_view.userInteractionEnabled = YES;
    }
    return _bg_view;
}

-(UIImageView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rules_title"]];
    }
    return _titleView;
}

-(UIWebView *)content
{
    if (!_content) {
        _content =[[UIWebView alloc] init];
        [_content setBackgroundColor:[UIColor clearColor]];
        _content.opaque = NO;
    }
    return _content;
}

-(UIButton *)reward
{
    if (!_reward) {
        _reward = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reward setImage:[UIImage imageNamed:@"rules_btn"] forState:UIControlStateNormal];
        [_reward addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reward;
}

-(void)setContentString:(NSString*)string
{
    [self.content loadHTMLString:string baseURL:nil];
}

-(void)updateConstraints
{
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    [self.bg_view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bg_view.centerX);
        make.top.equalTo(self.bg_view.top).with.offset(150);
    }];
    
    [self.content makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bg_view).with.offset(-k_Margin*2);
        make.bottom.equalTo(self.reward.top).with.offset(-20);
        make.centerX.equalTo(self.bg_view);
        make.top.equalTo(self.titleView.bottom).with.offset(20);
    }];
    
    [self.reward makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bg_view.centerX);
        make.top.equalTo(self.content.bottom).with.offset(20);
        make.bottom.equalTo(self.bg_view.bottom).with.offset(-40);
    }];
    
    [super updateConstraints];
}

-(void)dismiss:(id)sender
{
    [self removeFromSuperview];
}

-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self remakeConstraints:^(MASConstraintMaker *make) {
//        //make.edges.equalTo([UIApplication sharedApplication].keyWindow);
//        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.top);
//    }];
//    [UIView animateWithDuration:5 animations:^{
//        [self makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo([UIApplication sharedApplication].keyWindow);
//        }];
//        [self layoutIfNeeded];
//    }completion:^(BOOL finished) {
//        [self setNeedsUpdateConstraints];
//    }];
    
}

@end
