//
//  RedPocketButton.m
//  mckfc
//
//  Created by 华印mac-001 on 16/8/31.
//  Copyright © 2016年 Shanghai Impression Culture Communication Co.,Ltd. All rights reserved.
//

#import "RedPocketButton.h"
#define animationTime 0.25

@interface RedPocketButton()

@property (strong, nonatomic) UIImageView* detail;

@end

@implementation RedPocketButton
{
    UIView* background;
}

-(instancetype)init
{
    self = [super init];
    [self setImage:[UIImage imageNamed:@"redPocket"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

-(UIButton *)claim
{
    if (!_claim) {
        _claim = [UIButton buttonWithType:UIButtonTypeCustom];
        [_claim setTitle:@"查看领取规则" forState: UIControlStateNormal];
        [_claim setBackgroundColor:COLOR_WithHex(0xff4d4d)];
        [_claim setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _claim.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _claim.layer.cornerRadius = 3;
        _claim.layer.masksToBounds = YES;
        
    }
    return _claim;
}

-(UITextView *)content
{
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.font = [UIFont systemFontOfSize:18];
        _content.textAlignment = NSTextAlignmentCenter;
        _content.textColor = COLOR_WithHex(0xec4d35);
        _content.editable = NO;
    }
    return _content;
}

-(UIImageView *)detail
{
    if (!_detail) {
        _detail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPocketDetail"]];
        [_detail setFrame:CGRectMake(0, -kScreen_Width, kScreen_Width, kScreen_Width)];
        _detail.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_detail addGestureRecognizer:tap];

    }
    return _detail;
}

-(void)attachToView:(UIView*)view
{
    [view addSubview:self];
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(80, 80));
        make.right.equalTo(view.right).with.offset(-10);
        make.bottom.equalTo(view.bottom).with.offset(-20);
    }];
}

-(void)didTapButton:(id)sender
{
    [self attachRedPocketView];
}

-(void)attachRedPocketView
{
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [background setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
    [[UIApplication sharedApplication].keyWindow addSubview:background];
    
    [background addSubview:self.detail];
    
    [self.detail addSubview:self.claim];
    [self.claim makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_detail.centerX);
        make.bottom.equalTo(_detail.bottom);
        make.size.equalTo(CGSizeMake(110, 24));
    }];
    
    [self.detail addSubview:self.content];
    
    [self.content makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_detail.centerX);
        make.bottom.equalTo(_detail.bottom).with.offset(-9.6/18.8*kScreen_Width);
        make.width.equalTo(_detail.width).with.offset(-(13.4/18.8*kScreen_Width));
        make.top.equalTo(_detail.top).with.offset(5/18.8*kScreen_Width);
    }];
    
    [self showAnimations];
}

-(void)showAnimations
{
    //animations
    [UIView animateWithDuration:animationTime animations:^{
        [_detail setFrame:CGRectMake(0, kScreen_Height/2, kScreen_Width, kScreen_Width)];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animationTime+0.1 animations:^{
            [_detail setFrame:CGRectMake(0, kScreen_Height/2-kScreen_Width/2-40, kScreen_Width, kScreen_Width)];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:animationTime-0.1 animations:^{
                [_detail setFrame:CGRectMake(0, kScreen_Height/2-kScreen_Width/2, kScreen_Width, kScreen_Width)];
            }];
        }];
    }];
}

-(void)dismiss:(id)sender
{
    [background removeFromSuperview];
    [_detail setFrame:CGRectMake(0, -kScreen_Width, kScreen_Width, kScreen_Width)];
}

-(void)setString:(NSString*)string
{
    if ([string isEqualToString:@""] || string ==nil) {
        self.detail.image = [UIImage imageNamed:@"redPocketDetail_empty"];
        self.content.hidden = YES;
    }
    else
    {
        self.detail.image = [UIImage imageNamed:@"redPocketDetail"];
        self.content.text = string;
        self.content.hidden = NO;
    }
}

@end
